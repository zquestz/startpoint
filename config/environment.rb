# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.12' unless defined? RAILS_GEM_VERSION

# Add these paths manually since passenger sometimes won't.
ENV['PATH'] = '/usr/local/bin:/opt/local/bin:' + ENV['PATH']

# Setup Recaptcha keys
# Below is an unlimited use key, however please get your own.
# You can get a key at recapcha.com
ENV['RECAPTCHA_PUBLIC_KEY']  = '6LfLkLsSAAAAAIiRFw6YkII3_J0SPMWqGOS6hcsO'
ENV['RECAPTCHA_PRIVATE_KEY'] = '6LfLkLsSAAAAAAcWGfI4BJKvmIzhuTwm32ZF_31W'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

# Include extensions to ruby classes
# Right now this is limited to Hashes.
require 'extend_ruby_classes'

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.autoload_paths += %W( #{RAILS_ROOT}/extras )
  %w(middleware).each do |dir|
    config.autoload_paths << "#{RAILS_ROOT}/app/#{dir}" 
  end

  # This app uses bundler. Do not put gem entries here.
  
  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
end

# Add Caching to i18n
require "i18n/backend/cache" 
I18n::Backend::Simple.send(:include, I18n::Backend::Cache)

# Remove LESS header
Less::More.header = false

# Setup asset hosts.
unless Setting.asset_host.blank?
  ActionController::Base.asset_host = Setting.asset_host
end