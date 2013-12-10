class StructureSearch
  # params: params
  #     name:          fulltext
  #     subject_id:    slug of a subject
  #     audience_ids:  [1, 2, 3]
  #     level_ids:     [1, 2, 3]
  def self.search params
    params[:sort] ||= 'rating_desc'
    retrieve_location params

    @search = Sunspot.search(Structure) do
      fulltext params[:name]                             if params[:name].present?

      # --------------- Geolocation
      if params[:bbox_sw] && params[:bbox_ne]
        with(:location).in_bounding_box(params[:bbox_sw], params[:bbox_ne])
      else
        with(:location).in_radius(params[:lat], params[:lng], params[:radius] || 7, bbox: (params.has_key?(:bbox) ? params[:bbox] : true)) if params[:lat].present? and params[:lng].present?
      end
      with(:subject_slugs).any_of [params[:subject_id]]  if params[:subject_id].present?

      # --------------- Subjects
      # For the home screen link "Autres"
      if params[:exclude].present?
        without(:subject_slugs, params[:exclude])
      elsif params[:other].present?
        without(:subject_slugs, Subject.stars.map(&:slug))
      end

      # --------------- Other filters
      with(:audience_ids).any_of    params[:audience_ids].map(&:to_i)     if params[:audience_ids].present?
      with(:level_ids).any_of       params[:level_ids].map(&:to_i)        if params[:level_ids].present?

      %w(per_course book_ticket annual_subscription trimestrial_subscription).each do |name|
        with("#{name}_max_price".to_sym).greater_than params["#{name}_min_price".to_sym] if params["#{name}_min_price".to_sym].present?
        with("#{name}_min_price".to_sym).less_than    params["#{name}_max_price".to_sym] if params["#{name}_max_price".to_sym].present?
      end
        # with(:max_price).greater_than params[:min_price]                    if params[:min_price].present?
        # with(:min_price).less_than    params[:max_price]                    if params[:max_price].present?

      with :active,  true

      with :has_logo   ,  params[:has_logo]    if params[:has_logo].present?

      order_by :has_admin, :desc
      order_by :has_logo, :desc
      if params[:sort] == 'rating_desc'
        order_by :nb_comments, :desc
      elsif params[:sort] == 'relevancy'
        order_by :has_comment, :desc
      end
      paginate page: (params[:page] || 1), per_page: (params[:per_page] || 15)
    end

    @search
  end

  def self.retrieve_location params
    if params[:lat].blank? or params[:lng].blank?
      params[:lat] = 48.8592
      params[:lng] = 2.3417
    end

    [params[:lat], params[:lng]]
  end

  def self.similar_profile structure, limit=3
    parent_subject = structure.subjects.at_depth(0).first
    @structures    = []
    if parent_subject
      @structures << StructureSearch.search({lat: structure.latitude,
                                            lng: structure.longitude,
                                            radius: 10,
                                            sort: 'rating_desc',
                                            has_logo: true,
                                            per_page: 3,
                                            subject_id: parent_subject.slug
                                          }).results
      # If there is not enough with the same subjects
    end
    @structures = @structures.flatten
    if @structures.length < 3
      @structures << StructureSearch.search({lat: structure.latitude,
                                            lng: structure.longitude,
                                            radius: 500,
                                            sort: 'rating_desc',
                                            has_logo: true,
                                            per_page: (3 - @structures.length)
                                          }).results
    end
    @structures = @structures.flatten
    return @structures[0..(limit - 1)]
  end
end
