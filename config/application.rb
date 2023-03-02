require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SolotodoMaquetismoApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.api_only = true

    
    # Adaptador para las colas
    config.active_job.queue_adapter = :sidekiq
    # config.autoloader = :classic
    
    # Sidekiq Web
    # This also configures session_options for use below
    config.session_store :cookie_store, key: '_interslice_session'
    # Required for all session management (regardless of session_store)
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use config.session_store, config.session_options
  
  end
end
