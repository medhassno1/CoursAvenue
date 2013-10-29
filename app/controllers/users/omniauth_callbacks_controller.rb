class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def passthru
    # render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    # Or alternatively,
    raise ActionController::RoutingError.new('Not Found')
  end

  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    # @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
    # If refers to a user (ex: when user is not registered and receive a message from a teacher)
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      # Merge user if it comes from a new message.
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', :kind => 'Facebook'
      if request.referer.include?('token') and request.referer.include?('email')
        request_params = Rack::Utils.parse_nested_query(request.referer.split('?')[1])
        requested_user = User.where(email: request_params['email']).first
        if requested_user.reset_password_token_valid?(request_params['token'])
          @user.merge(requested_user)
        end
        flash[:notice] += '<br>Vous pouvez maintenant envoyer votre message.'
      end

      # redirect_to root_path, :event => :authentication, :current_user => @user
      sign_in_and_redirect @user, event: :authentication
    else
      session['devise.facebook_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_url
    end
  end
end
