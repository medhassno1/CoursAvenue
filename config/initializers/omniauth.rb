OmniAuth.config.logger = Rails.logger

# Already in devise.rb
Rails.application.config.middleware.use OmniAuth::Builder do

  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'], provider_ignores_state: true, display: 'popup',
            scope: 'email,user_location,age,user_birthday,gender', display: 'popup'
end
