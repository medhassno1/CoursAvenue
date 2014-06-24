class StatisticsController < ApplicationController

  def create
    if params[:structure_ids]
      params[:structure_ids].each do |structure_id|
        Statistic.create_action(params[:action_type], structure_id, current_user, params[:fingerprint], request.ip, params[:infos]) unless current_pro_admin
      end
    end
    respond_to do |format|
      format.js { render nothing: true }
    end
  end
end
