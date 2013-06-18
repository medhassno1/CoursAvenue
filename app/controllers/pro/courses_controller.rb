# encoding: utf-8
class Pro::CoursesController < InheritedResources::Base
  before_filter :authenticate_pro_admin!
  before_filter :load_structure

  layout 'admin'

  load_and_authorize_resource :structure, except: [:create, :update]

  def duplicate
    @course = Course.find params[:id]
    @course.duplicate!
    redirect_to pro_structure_path(@structure), notice: "Le cours à bien été dupliqué."
  end

  def activate
    @course = Course.find params[:id]
    if @course.activate!
      redirect_to pro_structure_path(@structure), notice: "Le cours sera visible sur CoursAvenue dans quelques minutes"
    else
      redirect_to pro_structure_path(@structure), alert: "Le cours n'a pu être mis en ligne.<br>Assurez vous que le tarif et le planning sont bien renseignés."
    end
  end

  def disable
    @course = Course.find params[:id]
    if @course.update_attribute :active, false
      redirect_to pro_structure_path(@structure), notice: "Le cours n'est plus affiché sur CoursAvenue"
    else
      redirect_to pro_structure_path(@structure), alert: "Le cours n'a pu être mis hors ligne. Assurez vous que le tarif et le planning sont bien renseignés."
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
      success.html { redirect_to pro_course_prices_path(@course), notice: 'Vous pouvez maintenant définir les tarifs pour ce cours' }
      failure.html { render template: 'pro/courses/form' }
    end
  end

  def update_price
    if can? :edit, @course
      errors = false
      if params[:price_details].present?
        @course.update_attributes price_details: params[:price_details]
      end
      if params[:individual_course_price][:amount].present?
        @individual_price = @course.prices.where{libelle == 'prices.individual_course'}.first_or_initialize
        errors = !@individual_price.update_attributes(params[:individual_course_price])
      end
      if params[:price] and params[:price][:amount].present?
        @subscription = @course.prices.where{libelle != 'prices.individual_course'}.first_or_initialize
        errors = errors or !@subscription.update_attributes(params[:price])
      end
      if params[:book_ticket] and params[:book_ticket][:amount].present?
        @book_ticket = @course.book_tickets.where{number == 10}.first_or_initialize
        errors = errors or !@book_ticket.update_attributes(params[:book_ticket])
      end
      if params[:registration_fee] and params[:registration_fee][:amount].present?
        @registration_fee = @course.registration_fees.first_or_initialize
        errors = errors or !@registration_fee.update_attributes(params[:registration_fee])
      end

      respond_to do |format|
        if errors
          @individual_price ||= @course.prices.where{libelle == 'prices.individual_course'}.first || @course.prices.build
          @subscription     ||= @course.prices.where{libelle != 'prices.individual_course'}.first || @course.prices.build
          @book_ticket      ||= @course.book_tickets.where{number == 10}.first || @course.book_tickets.build
          @registration_fee ||= @course.registration_fees.first || @course.registration_fees.build
          format.html{ render template: 'pro/prices/index' }
        else
          @course.activate!
          if @course.plannings.empty?
            format.html{ redirect_to pro_course_plannings_path(@course), notice: 'Vous pouvez maintenant définir le planning du cours' }
          else
            format.html{ redirect_to pro_structure_path(@structure), notice: 'Les prix ont bien été mis à jour' }
          end
        end
      end
    else
      redirect_to pro_structure_path(@structure), alert: "Votre compte n'est pas encore activé, vous ne pouvez pas éditer les cours actifs"
    end
  end

  def update
    authorize! :edit, @course
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
