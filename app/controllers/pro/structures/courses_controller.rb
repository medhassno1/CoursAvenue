# encoding: utf-8
class Pro::Structures::CoursesController < Pro::ProController
  layout 'admin'

  before_action :authenticate_pro_admin!
  before_action :load_structure

  load_and_authorize_resource :structure, find_by: :slug

  def new
    @course = @structure.courses.build
  end

  def index
    @structure = Structure.friendly.find params[:structure_id]
    @courses   = @structure.courses.without_open_courses.order('name ASC')
  end

  def copy_prices_from
    @course                   = Course.friendly.find params[:id]
    @course_to_duplicate_from = Course.friendly.find params[:course_id]
    @course.copy_prices_from!(@course_to_duplicate_from)
    redirect_to pro_structure_course_prices_path(@structure, @course), notice: 'Les tarifs ont été mis à jour.'
  end

  def duplicate
    @course = Course.friendly.find params[:id]
    duplicate_course = @course.duplicate!
    session[:duplicate]            = true
    session[:duplicated_course_id] = duplicate_course.id
    redirect_to pro_structure_courses_path(@structure), notice: 'Le cours à bien été dupliqué.'
  end

  def activate_ok_nico
    @course = Course.friendly.find params[:id]
    respond_to do |format|
      @course.update_column :ok_nico, true
      format.js { render nothing: true }
    end
  end

  def disable_ok_nico
    @course = Course.friendly.find params[:id]
    respond_to do |format|
      @course.update_column :ok_nico, false
      format.js { render nothing: true }
    end
  end

  def activate
    @course = Course.friendly.find params[:id]
    respond_to do |format|
      if @course.activate!
        @course.plannings.map(&:index)
        if @course.is_open?
          format.html { redirect_to (request.referrer || pro_open_courses_path), notice: 'Le cours a bien été activé' }
          format.js { render nothing: true }
        else
          format.html { redirect_to (request.referrer || pro_structure_courses_path(@structure)), notice: 'Le cours sera visible sur CoursAvenue dans quelques minutes' }
        end
      else
        format.html { redirect_to pro_structure_courses_path(@structure), alert: "Le cours n'a pu être mis en ligne.<br>Assurez vous que les tarif et les plannings sont bien renseignés." }
        format.js { render nothing: true }
      end
    end
  end

  def disable
    @course = Course.friendly.find params[:id]
    @course.active = false
    respond_to do |format|
      if @course.save
        @course.plannings.map(&:index)
        if @course.is_open?
          format.js { render nothing: true }
          format.html { redirect_to pro_open_courses_path, notice: 'Le cours a bien été activé' }
        else
          format.js { render nothing: true }
          format.html { redirect_to pro_structure_courses_path(@structure), notice: "Le cours n'est plus affiché sur CoursAvenue" }
        end
      else
        format.js { render nothing: true }
        format.html { redirect_to pro_structure_courses_path(@structure), alert: "Le cours n'a pu être mis hors ligne. Assurez vous que les tarif et les plannings sont bien renseignés." }
      end
    end
  end

  def edit
    @course = Course.friendly.find params[:id]
  end

  def create
    @course           = Course.new params[:course]
    @course.structure = @structure
    respond_to do |format|
      if @course.save
        format.html { redirect_to pro_structure_course_prices_path(@structure, @course), notice: 'Vous pouvez maintenant définir les tarifs pour ce cours' }
      else
        format.html { render action: :new}
      end
    end
  end

  def update
    @course = Course.friendly.find params[:id]
    had_price_before = @course.prices.any?
    respond_to do |format|
      if @course.update_attributes params[:course]
        # We update the prices through the course
        if params[:course][:prices_attributes].present?
          # Redirect to planning page if the course didn't have price before
          # Unless, we bring him to the course list page
          if had_price_before
            format.html { redirect_to pro_structure_course_prices_path(@structure, @course), notice: 'Les tarifs ont bien été mis à jour' }
          else
            format.html { redirect_to pro_structure_course_plannings_path(@structure, @course), notice: 'Les tarifs ont bien été mis ajouté au cours, renseignez maintenant votre planning' }
          end
        else
          format.html { redirect_to pro_structure_courses_path(@structure), notice: 'Le cours à bien été mis à jour' }
          format.json { render json: { done: true } }
        end
      else
        if params[:course][:prices_attributes].present?
          format.html { render template: 'pro/structures/courses/prices/index' }
        else
          format.html { render action: :new}
        end
      end
    end
  end

  def destroy
    @course = Course.friendly.find params[:id]
    respond_to do |format|
      if @course.destroy
        format.html { redirect_to pro_structure_courses_path(@structure), notice: "Le cours a bien été supprimé" }
      else
        format.html { redirect_to pro_structure_courses_path(@structure), alert: "Une erreur s'est produite" }
      end
    end
  end

  private

  def load_structure
    @structure = Structure.friendly.find(params[:structure_id])
  end
end
