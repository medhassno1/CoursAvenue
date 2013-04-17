# encoding: utf-8
class Pro::TeachersController < InheritedResources::Base
  before_filter :authenticate_pro_admin!, except: [:index]

  layout 'admin'

  belongs_to :structure
  load_and_authorize_resource :structure, except: [:index]

  def index
    @teacher = Teacher.new
    index!
  end

  def create
    create! do |success, failure|
      success.html { redirect_to pro_structure_teachers_path(@structure) }
      failure.html { redirect_to pro_structure_teachers_path(@structure) }
    end
  end

  def edit
    @teachers = @structure.teachers.reject{|teacher| teacher == resource}
    edit! do |format|
      format.html { render template: 'pro/teachers/index' }
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to pro_structure_teachers_path(@structure) }
    end
  end

  def destroy
    destroy! do |success, failure|
      success.html { redirect_to pro_structure_teachers_path(@structure) }
      failure.html { render template: 'pro/teachers/index' }
    end
  end
end
