class Pro::Structures::Newsletters::MailingListsController < ApplicationController
  before_action :authenticate_pro_admin!
  before_action :set_structure_and_newsletter

  def file_import
  end

  def bulk_import
    UserProfile.delay.batch_create(@structure, params[:emails], newsletter_id: @newsletter.id)

    respond_to do |format|
      if params[:email].present?
        format.json { render json: { message: "L'import est en cours, nous vous enverrons un mail dès l'import terminé." } }
      else
        format.json { render json: { message: "Veuillez renseigner des adresses emails à importer." }, status: 400 }
      end
    end
  end

  private

  def set_structure_and_newsletter
    @structure  = Structure.find(params[:structure_id])
    @newsletter = @structure.newsletters.find(params[:newsletter_id])
  end
end
