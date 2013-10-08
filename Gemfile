# encoding: utf-8
source 'https://rubygems.org'

ruby '1.9.3'
gem 'rails', '3.2.14'

# Gems used only for assets and not required
# in production environments by default.

# gem 'thin'
gem 'unicorn'
gem 'pg'
gem 'newrelic_rpm'          , '~> 3.6.6.147'

gem 'nutshell-crm'

# For the blog
gem 'rack-reverse-proxy', require: 'rack/reverse_proxy'

gem 'delocalize', '~> 0.3.1'

# Caching
gem 'memcachier'
gem 'dalli'
gem 'bust_rails_etags'          # https://github.com/n8/bust_rails_etags
gem 'rack-cors'                 , require: 'rack/cors'

gem 'active_hash'                , '~> 1.0.0'
gem 'zeroclipboard-rails'

group :assets do
  gem 'sass-rails'              , '~> 3.2.4'
  gem 'uglifier'                , '>= 1.0.3'
  gem 'coffee-rails'            , '~> 3.2.1'
end

gem 'gravatar_image_tag'        , '~> 1.1.3'

gem 'auto_html'                 , '~> 1.6.0'

gem 'delayed_job_active_record' , '~> 0.4.4'
gem 'hirefire-resource'
gem 'hirefire'

gem 'daemons'
# gem 'whenever'                  , '~> 0.8.2'
# gem 'exceptional'

# gem 'js-routes'                 , '~> 0.9.3'
gem 'font-awesome-rails'        , '~> 3.2.1.3'
gem 'jquery-rails'              , '~> 3.0.4'
gem 'compass'                   , '~> 0.12.2'
gem 'compass-rails'             , '~> 1.0.3'
gem 'compass-inuit'             , '~> 5.0.1'
gem 'asset_sync'                , '~> 0.5.4'
gem 'haml'                      , '~> 3.1.7'

gem 'progress_bar'

gem 'kaminari'                  , '~>0.14.1'
gem 'paperclip'                 , '~>3.5.1'
gem 'aws-sdk'                   , '~>1.8.0'
gem 'squeel'                    , '~>1.0.14'
gem 'ancestry'                  , '~>2.0.0'

gem 'gmaps4rails'               , '~>1.5.6'
gem 'geocoder'                  , '~>1.1.6'
gem 'active_model_serializers'  , '~>0.6.0'

gem 'friendly_id'               , '~> 4.0.9'
gem 'simple_form'               , '~> 2.0.4'
gem 'inherited_resources'       , '~> 1.3.1'

gem 'cancan'                    , '~> 1.6.9'
gem 'devise'                    , '~> 2.2.3'
gem 'devise_invitable'          , '~> 1.1.5'
gem 'omniauth-facebook'         , '~> 1.4.0'
gem 'omnicontacts'              , '~> 0.3.4'

gem 'sunspot'                   , '~> 2.0.0'
gem 'sunspot_solr'              , '~> 2.0.0'
gem 'sunspot_rails'             , '~> 2.0.0'
gem 'sunspot-rails-tester'      , '~> 1.0.0'

gem 'acts_as_paranoid'          , '~> 0.4.0'

gem 'sitemap_generator'         , '~> 3.4'
gem 'gibbon'                    , '~> 0.4.6'

group :production do
  # gem 'therubyracer'
  gem 'execjs'
  gem 'rails_12factor'
end

group :test do
  gem 'factory_girl_rails', '~> 4.2.1'
  gem 'rspec-rails'       , '~> 2.13.2'
  gem 'rspec-instafail'   , '~> 0.2.4'
  gem 'forgery'           , '~> 0.5.0'
  gem 'simplecov'         , '~> 0.7.1', require: false
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'awesome_print'
  gem 'meta_request', '0.2.1'
  gem 'delorean'
end

group :development, :test do
  gem 'debugger'
  # gem 'linecache19'      , '0.5.12'
  # gem 'ruby-debug-base19', '0.11.25'
end

# For emails
gem 'roadie', '~> 2.4.1'

# gem 'thin'

# Deploy with Capistrano
# gem 'capistrano'

