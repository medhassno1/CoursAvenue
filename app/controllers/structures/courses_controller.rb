# encoding: utf-8
class Structures::CoursesController < ApplicationController
  include ActionView::Helpers::NumberHelper

  def index
    @structure       = Structure.find params[:structure_id]
    @planning_search = PlanningSearch.search(params)
    @plannings       = @planning_search.results
    @courses         = []
    # TODO Refactor this.
    @plannings.group_by(&:course_id).each do |course_id, plannings|
      course = Course.find(course_id)
      @courses << {
        id:                    course.id,
        name:                  course.name,
        description:           course.description,
        type:                  course.type_name,
        min_price_amount:      number_to_currency(course.best_price.try(:amount)),
        min_price_libelle:     course.best_price.try(:localized_libelle),
        has_free_trial_lesson: course.has_free_trial_lesson?,
        data_url:              structure_course_url(@structure, course),
        subjects:              course.subjects.map(&:name).join(', '),
        plannings:             ActiveModel::ArraySerializer.new(plannings, each_serializer: PlanningSerializer)
      }
    end

    respond_to do |format|
      format.json { render json: @courses }
    end
  end

  def show
    @course             = Course.friendly.find(params[:id])
    @comment            = @course.comments.build
    @comments           = @structure.comments.accepted.reject(&:new_record?)
    @medias             = @structure.medias
    @locations          = @course.locations
    @places             = @course.places
    if @course.is_lesson?
      @plannings = @course.plannings.order('week_day ASC, start_time ASC')
    else
      @plannings = @course.plannings.order('start_date ASC, start_time ASC')
    end
    @plannings_grouped_by_places = @plannings.future.group_by(&:place)
    @subjects                    = @course.subjects
    @price_range                 = @course.price_range
    @prices                      = @course.book_tickets + @course.subscriptions
    @location_index_hash         = {}
    location_index               = 0
    @locations.each_with_index do |location, index|
      @location_index_hash[location] = index + 1
    end
    respond_to do |format|
      if @course.active
        format.html
      else
        format.html { redirect_to root_path, notice: "Ce cours n'est pas visible.", status: 301 }
      end
    end
  end
end
