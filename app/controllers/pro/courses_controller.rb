# encoding: utf-8
class Pro::CoursesController < InheritedResources::Base
  before_filter :authenticate_pro_admin!
  belongs_to :structure

  layout 'admin'

  before_filter :load_structure
  load_and_authorize_resource :structure, except: [:create, :update]

  def activate
    if current_pro_admin.active
      @course = Course.find params[:id]
      respond_to do |format|
        if @course.update_attribute :active, true
          redirect_to pro_structure_path(@structure), notice: "Le cours est maintenant visible sur CoursAvenue"
        else
          redirect_to pro_structure_path(@structure), alert: "Le cours n'a pu être mis en ligne. Assurez vous que toutes les informations sont bien renseignés."
        end
      end
    else
      redirect_to pro_structure_path(@structure), alert: "Votre compte n'est pas encore activé, vous ne pouvez pas encore mettre vos cours en ligne"
    end
  end

  def disable
    if current_pro_admin.active
      @course = Course.find params[:id]
      respond_to do |format|
        if @course.update_attribute :active, false
          redirect_to pro_structure_path(@structure), notice: "Le cours n'est plus affiché sur CoursAvenue"
        else
          redirect_to pro_structure_path(@structure), alert: "Le cours n'a pu être mis hors ligne. Assurez vous que toutes les informations sont bien renseignés."
        end
      end
    else
      redirect_to pro_structure_path(@structure), alert: "Votre compte n'est pas encore activé, vous ne pouvez pas mettre ce cours hors ligne"
    end
  end

  def edit
    if can? :edit, @course
      edit!
    else
      redirect_to pro_structure_path(@structure), alert: "Votre compte n'est pas encore activé, vous ne pouvez pas éditer les cours actifs"
    end
  end

  def create
    @course           = Course.new params[:course]
    @course.structure = @structure
    create! do |success, failure|
      success.html { redirect_to pro_course_plannings_path(@course), notice: 'Vous pouvez maintenant créer le planning de ce cours' }
      failure.html { redirect_to new_pro_structure_course_path(@structure), alert: 'Impossible de créer le cours.' }
    end
  end

  def update_price
    errors = false
    if params[:individual_course_price][:amount].present?
      @individual_price = @course.prices.where{libelle == 'prices.individual_course'}.first || @course.prices.build
      errors = @individual_price.update_attributes(params[:individual_course_price])
    end
    if params[:price] and params[:price][:amount].present?
      @subscription = @course.prices.where{libelle != 'prices.individual_course'}.first || @course.prices.build
      errors = errors and @subscription.update_attributes(params[:price])
    end
    if params[:book_ticket] and params[:book_ticket][:price].present?
      @book_ticket = @course.book_tickets.where{number == 10}.first || @course.book_tickets.build
      errors = errors and @book_ticket.update_attributes(params[:book_ticket])
    end

    respond_to do |format|
      if errors
        format.html{ redirect_to pro_structure_path(@structure) }
      else
        format.html{ redirect_to pro_course_prices_path(@course), error: 'Vous devez renseigner au moins un prix' }
      end
    end
  end

  def update
    if params[:course].delete(:delete_image) == '1'
      resource.image.clear
    end
    update! do |success, failure|
      success.html { redirect_to pro_structure_path(@structure), notice: 'Le cours à bien été mis à jour' }
      failure.html { render template: 'pro/courses/form' }
    end
  end

  def destroy
    if can? :edit, @course
      destroy! do |success, failure|
        success.html { redirect_to pro_structure_path(@structure) }
      end
    else
      redirect_to pro_structure_path(@structure), alert: "Votre compte n'est pas encore activé, vous ne pouvez pas supprimer les cours actifs"
    end
  end

  private

  def load_structure
    if params[:structure_id]
      @structure = Structure.find(params[:structure_id])
    else
      @course    = Course.find(params[:id]) if params[:id]
      @structure = @course.structure
    end
  end
end
