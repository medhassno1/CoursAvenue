class StructureShowSerializer < ActiveModel::Serializer
  include StructuresHelper
  include ActionView::Helpers::TextHelper

  cached
  delegate :cache_key, to: :object

  attributes :id, :name, :slug, :rating, :street, :zip_code, :description, :description_short,
             :logo_thumb_url, :data_url, :query_params, :courses, :courses_count,
             :has_courses, :plannings_count, :has_plannings, :about, :about_bis, :about_genre,
             :min_price_amount, :min_price_libelle, :max_price_amount, :max_price_libelle, :has_price_range,
             :has_free_trial_course, :teaches_at_home, :audience, :funding_types, :gives_group_courses,
             :gives_individual_courses, :structure_type, :has_promotion, :tag_names, :given_course_types,
             :given_funding_type, :places_count, :comments, :subjects, :has_teachers, :has_only_one_more_info,
             :phone_numbers, :trainings_courses, :lessons_and_privates, :has_published_courses, :is_sleeping, :website, :premium, :has_trial_courses

  has_many :comments, serializer: CommentSerializer
  has_many :places  , serializer: PlaceSerializer
  has_many :teachers, serializer: ShortSerializer

  def comments
    object.comments.accepted.limit(5)
  end

  def courses
    if @options[:planning_groups]
      object.courses.active.where(id: @options[:planning_groups].keys).map do |course|
        CourseSerializer.new(course, plannings: @options[:planning_groups][course.id])
      end
    end
  end

  def places_count
    object.places.count
  end

  def places
    if @options[:place_ids].present?
      place_ids = @options[:place_ids]
      object.places.where( Place.arel_table[:id].eq_any(place_ids) )
    else
      object.places
    end
  end

  def description_short
    truncate(object.description, length: 500, separator: ' ') if object.description
  end

  def structure_type
    case object.structure_type
    when 'structures.association'
      "Association"
    when 'structures.company'
      "École"
    when 'structures.independant'
      "Professeur"
    end
  end

  def about
    I18n.t("structures.structure_type_contact.#{(object.structure_type.present? ? object.structure_type : 'structures.other')}")
  end

  def about_bis
    I18n.t("structures.structure_type_contact_bis.#{(object.structure_type.present? ? object.structure_type : 'structures.other')}")
  end

  def about_genre
    I18n.t("structures.structure_type_genre.#{(object.structure_type.present? ? object.structure_type : 'structures.other')}")
  end

  def funding_types
    object.funding_types.map{|funding| I18n.t(funding.name)}.join(', ')
  end

  def audience
    object.audiences.sort_by(&:order).map{|audience| I18n.t(audience.name)}.join(', ')
  end

  def has_free_trial_course
    object.has_free_trial_course
  end

  def min_price_amount
    object.min_price_amount.to_i
  end

  def max_price_amount
    object.max_price_amount.to_i
  end

  def has_price_range
    object.min_price_amount.present? and object.max_price_amount.present?
  end

  def has_plannings
    object.plannings_count.to_i > 0 if object.plannings_count
  end

  def courses_count
    object.courses.count
  end

  def has_courses
    object.courses.count > 0
  end

  def logo_thumb_url
    object.logo.url(:thumb) if object.logo.present?
  end

  def data_url
    subdomain = 'www'
    if Rails.env.production?
      host = 'coursavenue.com'
    elsif Rails.env.development?
      host = 'coursavenue.dev'
    elsif Rails.env.staging?
      host      = 'staging.coursavenue.com'
      subdomain = 'staging'
    end
    if @options[:jpo]
      jpo_structure_url(object, subdomain: subdomain, host: host, only_path: host.nil?)
    else
      structure_url(object, subdomain: subdomain, host: host, only_path: host.nil?)
    end
  end

  def query_params
    @options[:query]
  end

  def tag_names
    if @options[:jpo]
      object.open_course_subjects
    else
      tags = []
      tags << object.parent_subjects_string.split(';').collect do |subject_string|
        subject_string.split(':')[0]
      end
      tags << object.subjects_string.split(';').collect do |subject_string|
        subject_string.split(':')[0]
      end
      if object.course_names.present?
        "#{tags.flatten.uniq.join(', ')}, #{object.course_names}"
      else
        tags.flatten.uniq.join(', ')
      end
    end
  end

  def given_course_types
    types = []
    if object.gives_individual_courses
      types << 'Cours individuels'
    end
    if object.teaches_at_home and object.places.homes.any?
      if object.places.homes.first.radius.present?
        types << "Cours individuels à domicile (#{object.places.homes.first.city.name.capitalize} dans un rayon de #{object.places.homes.first.radius}km)"
      else
        types << "Cours individuels à domicile"
      end
    end
    if object.gives_group_courses
      types << 'Cours collectifs'
    end
    types.join('. ')
  end

  def given_funding_type
    object.funding_types.map{ |funding_type| I18n.t(funding_type.name)}.join(', ')
  end

  # TODO improve with subject_strings ?
  def subjects
    _subjects = []
    object.subjects.at_depth(0).uniq.each do |root_subject|
      child_subjects = object.subjects.at_depth(2).uniq.order('name ASC').select{ |subject|  subject.ancestry.start_with?(root_subject.id.to_s) }
      _subjects << {
        root_name: root_subject.name,
        child_names: child_subjects.map(&:name).join(', '),
        icon: "https://coursavenue-public.s3.amazonaws.com/public_assets/icons/subjects/#{root_subject.slug}.png"
      }
    end
    _subjects.sort_by(&:length).reverse
  end

  def has_teachers
    object.teachers.count > 0
  end

  def has_only_one_more_info
    return (object.funding_types.empty? and object.audiences.empty? and object.structure_type.nil?)
  end

  def phone_numbers
    object.phone_numbers.map{ |phone_number| readable_phone_number(phone_number.number) }.uniq
  end

  def has_published_courses
    object.courses.without_open_courses.detect(&:is_published?).present?
  end

  def trainings_courses
    if options[:discovery_pass]
      # Take only if there are plannings
      object.plannings.future.is_open_for_trial.group_by(&:course).select {|course| course.is_training? }.map(&:first)
    else
      object.courses.trainings.select(&:is_published?)
    end
  end

  def lessons_and_privates
    if options[:discovery_pass]
      # Take only if there are plannings
      object.plannings.is_open_for_trial.group_by(&:course).select {|course| course.is_lesson? or course.is_private? }.map(&:first)
    else
      object.courses.lessons.select(&:is_published?) + object.courses.privates.select(&:is_published?)
    end
  end

  def has_trial_courses
    object.has_trial_courses?
  end
end
