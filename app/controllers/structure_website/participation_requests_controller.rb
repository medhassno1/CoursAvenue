class StructureWebsite::ParticipationRequestsController < ApplicationController

  include ConversationsHelper

  skip_before_filter  :verify_authenticity_token, only: [:create]

  # For an example of a message controller see:
  # https://github.com/ging/social_stream/blob/master/base/app/controllers/messages_controller.rb
  def create
    @structure         = Structure.friendly.find params[:structure_id]
    @user              = User.where(email: request_params[:user][:email]).first_or_initialize(validate: false)
    @user.phone_number = request_params[:user][:phone_number]
    @user.first_name   = request_params[:user][:name]
    @user.save(validate: false)
    @structure.create_or_update_user_profile_for_user(@user, UserProfile::DEFAULT_TAGS[:contacts])

    @participation_request = ParticipationRequest.create_and_send_message request_params.merge(from_personal_website: true), @user
    respond_to do |format|
      if @participation_request.persisted?
        format.json { render json: { succes: true,
                                     popup_to_show: render_to_string(partial: 'structure_website/participation_requests/request_sent',
                                     formats: [:html]) } }
      else
        format.json { render json: { succes: false,
                                     popup_to_show: render_to_string(partial: 'structure_website/participation_requests/request_already_sent',
                                     formats: [:html]) },
                                     status: :unprocessable_entity }
      end
    end
  end

  def show
    @participation_request = ParticipationRequest.where(token: params[:id]).first
    if @participation_request.nil?
      redirect_to structure_website_presentation_path
    end
  end

  private

  def request_params
    params.require(:participation_request).permit(:course_id,
                                                  :planning_id,
                                                  :date,
                                                  :participants_attributes,
                                                  :structure_id,
                                                  user: [ :phone_number, :email, :name ],
                                                  message: [ :body ])
  end
end
