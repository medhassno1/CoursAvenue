class Pro::Structures::MessagesController < ApplicationController
  # For an example of a message controller see:
  # https://github.com/ging/social_stream/blob/master/base/app/controllers/messages_controller.rb

  before_action :authenticate_pro_admin!
  before_action :get_structure, :get_admin

  layout 'admin'

  def new
    @message = @admin.messages.build
  end

  private

  def get_structure
    @structure     = Structure.find params[:structure_id]
  end

  def get_admin
    @admin         = @structure.main_contact
  end
end
