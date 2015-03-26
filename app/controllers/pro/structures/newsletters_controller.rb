class Pro::Structures::NewslettersController < ApplicationController
  before_action :authenticate_pro_admin!
  before_action :set_structure
  before_action :set_layouts, only: [:new, :edit]

  layout 'admin'

  def index
    @newsletters = @structure.newsletters.includes(:mailing_list).decorate
  end

  def new
    if params[:id].present?
      @newsletter = @structure.newsletters.find params[:id]
    end
    @mailing_lists = @structure.mailing_lists
    @tags          = @structure.user_profiles.includes(:tags).flat_map(&:tags).map(&:name).uniq
  end

  def create
    @newsletter = @structure.newsletters.new required_params

    respond_to do |format|
      if @newsletter.save
        format.html { redirect_to mailing_list_pro_structure_newsletter_path(@structure, @newsletter),
                      notice: 'Bien enregistré' }
        format.json { render json: @newsletter, status: 201 }
      else
        format.html { render action: :edit }
        format.json { render json: { errors: @newsletter.errors.full_messages }, status: 422 }
      end
    end
  end

  def edit
    @newsletter = @structure.newsletters.includes(:blocs).find params[:id]
  end

  def update
    @newsletter = @structure.newsletters.includes(:blocs).find params[:id]

    respond_to do |format|
      if @newsletter.update_attributes required_params
        format.html { redirect_to pro_structure_newsletter_path(@structure, @newsletter),
                      notice: 'Bien enregistré' }
        format.json { render json: @newsletter, status: 200 }
      else
        format.html { render action: :edit }
        format.json { render json: { errors: @newsletter.errors.full_messages }, status: 422 }
      end
    end
  end

  def destroy
    @newsletter = @structure.newsletters.includes(:blocs).find params[:id]

    respond_to do |format|
      if @newsletter.destroy
        format.html { redirect_to pro_structure_newsletters_path(@structure),
                      notice: 'La newsletter a été supprimée avec succés' }
      else
        format.html { redirect_to pro_structure_newsletters_path(@structure),
                      error: "Erreur lors de la suppression de la newsletter, veillez rééssayer." }
      end
    end
  end

  # TODO: (Use a service?)
  # 1. Check all of the required informations are given.
  # 2. Generate the newsletter content.
  # 3. Send the newsletter to the associated mailing list.
  # 4. Redirect to
  #    - Index on success.
  #    - Back to current page on error.
  def send_newsletter
    @newsletter = @structure.newsletters.includes(:blocs).find params[:id]
    if @newsletter.ready?

      @newsletter.state = 'sending'
      @newsletter.save!

      NewsletterSender.delay.send_newsletter(@newsletter)
      redirect_to pro_structure_newsletters_path(@structure),
        notice: "Votre newsletter est en cours d'envoi, nous vous enverrons un mail dés l'envoi complet."
    else
      redirect_to pro_structure_newsletter_path(@structure, @newsletter),
        error: "Erreur lors de l'envoi de la newsletter, veuillez rééssayer."
    end
  end

  # Duplicate the newsletter and all associated models.
  def duplicate
    @newsletter = @structure.newsletters.includes(:blocs).find params[:id]
    duplicated_newsletter = @newsletter.duplicate!

    redirect_to pro_structure_newsletter_path(@structure, duplicated_newsletter), notice: 'Newsletter dupliquée avec succés.'
  end

  # Generate the newsletter as a String
  #
  # @return a String.
  def preview_newsletter
    @newsletter = @structure.newsletters.find params[:id]

    mail = NewsletterMailer.send_newsletter(@newsletter, nil)
    @body = MailerPreviewer.preview(mail)

    render layout: false
  end

  # Confirmation modal.
  def confirm
    @newsletter = @structure.newsletters.find(params[:id]).decorate

    render layout: false
  end

  # Metrics modal.
  def metrics
    @newsletter = @structure.newsletters.includes(:metric).find(params[:id]).decorate
    @metric = @newsletter.metric

    @metric.delayed_update if @metric.present?

    render layout: false
  end

  private

  # Set the current structure.
  def set_structure
    @structure = Structure.find(params[:structure_id])
  end

  # Set the layouts as usable JSON.
  def set_layouts
    @layouts      = Newsletter::Layout.all
    @layouts_json = Newsletter::Layout.all.as_json.map do |layout_|
      id = layout_["attributes"]["id"]

      layout_["attributes"].merge({
        image: view_context.asset_path("pro/newsletters/layouts/layout_#{id}.png"),
        image2x: view_context.asset_path("pro/newsletters/layouts/layout_#{id}@2x.png")
      })
    end
  end

  # Use the strong parameters.
  #
  # @return the permitted parameters as a Hash.
  def required_params
    params.require(:newsletter).permit(:title, :layout_id, :sender_name, :reply_to, :email_object,
                                      :newsletter_mailing_list_id)
  end
end
