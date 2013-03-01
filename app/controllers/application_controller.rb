class ApplicationController < ActionController::Base
  protect_from_forgery

  unless Rails.configuration.consider_all_requests_local
    rescue_from Exception,                            :with => :render_error
    rescue_from ActiveRecord::RecordNotFound,         :with => :render_not_found
    rescue_from ActionController::RoutingError,       :with => :render_not_found
    rescue_from ActionController::UnknownController,  :with => :render_not_found
    rescue_from ActionController::UnknownAction,      :with => :render_not_found
  end

  def render_not_found
    render :template => 'errors/not_found', :status => :not_found
  end

  def render_error
    render :template => 'errors/internal_server_error', :status => :not_found
  end
end
