# encoding: utf-8
class Pro::StructuresController < Pro::ProController
  before_filter :authenticate_admin!
  load_and_authorize_resource

  layout 'admin'

  def index
    @structures = Structure.order('name ASC').all
  end

  def show
    @structure = Structure.find params[:id]
    @courses   = @structure.courses
    respond_to do |format|
      if @structure.places.empty?
        format.html { redirect_to new_structure_place_path(@structure), notice: "Vous devez d'abord créé des lieux pour vos cours."}
      elsif @courses.empty?
        format.html{ redirect_to new_structure_course_path(@structure) }
      else
        format.html
      end
    end
  end

  def edit
    zad
    @structure = Structure.find(params[:id])
    @admin     = @structure.admins.first || Admin.new
  end

  def new
    @structure = Structure.new
    @admin     = current_admin
    @structure.admins << @admin
  end

  def update
    @structure = Structure.find params[:id]
    @admin     = (params[:admin][:id].blank? ? ::Admin.new : ::Admin.find(params[:admin].delete(:id)))

    if !@admin.new_record? and params[:admin][:password].blank?
      params[:admin].delete :password
      params[:admin].delete :password_confirmation
    end

    respond_to do |format|
      if @structure.save and @admin.update_attributes(params[:admin])
        format.html { redirect_to edit_structure_path @structure }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def create
    @admin           = (params[:admin][:id].blank? ? ::Admin.new : ::Admin.find(params[:admin].delete(:id)))
    @structure       = Structure.new(params[:structure])
    @structure.admins << @admin
    @admin.structure = @structure
    if !@admin.new_record? and params[:admin][:password].blank?
      params[:admin].delete :password
      params[:admin].delete :password_confirmation
    end
    respond_to do |format|
      if @structure.save and @admin.update_attributes(params[:admin])
        format.html { redirect_to structure_teachers_path(@admin.structure), :notice => t(".create_teacher") }
      else
        format.html { render action: :new }
      end
    end
  end
end
