# encoding: utf-8
class Pro::PlanningsController < InheritedResources::Base#Pro::ProController
  before_filter :authenticate_admin!
  layout 'admin'
  belongs_to :course
  before_filter :load_structure
  load_and_authorize_resource :structure

  def index
    @planning = Planning.new
    index!
  end

  def edit
    @planning  = Planning.find(params[:id])
    @plannings = @course.plannings.reject { |planning| planning == @planning }
    render template: 'pro/plannings/index'
  end

  def create
    @planning        = Planning.new(params[:planning])
    @planning.course = @course
    set_dates_and_times

    respond_to do |format|
      if @planning.save
        format.html { redirect_to course_plannings_path(@course) }
      else
        format.html { render template: 'pro/plannings/index' }
      end
    end
  end

  def update
    @planning        = Planning.find(params[:id])
    @planning.course = @course
    set_dates_and_times

    respond_to do |format|
      if @planning.update_attributes(params[:planning])
        format.html { redirect_to course_plannings_path(@course) }
      else
        format.html { render template: 'pro/plannings/index' }
      end
    end
  end

  def destroy
    destroy! do |success, failure|
      success.html { redirect_to course_plannings_path(@course) }
    end
  end

  private

  def set_dates_and_times
    params[:planning][:start_time]  = TimeParser.parse_time_string params[:planning][:start_time]  if params[:planning][:start_time].present?
    params[:planning][:end_time]    = TimeParser.parse_time_string params[:planning][:end_time]    if params[:planning][:end_time]  .present?
    params[:planning][:duration]    = TimeParser.parse_time_string params[:planning][:duration]    if params[:planning][:duration].present?

    if params[:planning][:end_time].blank? and params[:planning][:duration].present?
      params[:planning][:end_time]   = TimeParser.end_time_from_duration(params[:planning][:start_time], params[:planning][:duration])
    elsif params[:planning][:end_time].present? and  params[:planning][:duration].blank?
      params[:planning][:duration]   = TimeParser.duration_from params[:planning][:start_time], params[:planning][:end_time]
    end
  end

  def load_structure
    @course    = Course.find(params[:course_lesson_id] || params[:course_workshop_id] || params[:course_training_id] || params[:course_id])
    @structure = @course.structure
  end
end
