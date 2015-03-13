class NewsletterController < ApplicationController

  before_action :set_structure

  def show
    @newsletter = @structure.newsletters.includes(:blocs).find params[:id]

    mail = NewsletterMailer.send_newsletter(@newsletter, nil)
    @body = MailerPreviewer.preview(mail)

    render layout: false
  end

  def unsubscribe
  end

  private

  def set_structure
    @structure = Structure.find(params[:structure_id])
  end
end
