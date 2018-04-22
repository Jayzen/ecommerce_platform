require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ecommerce
  class Application < Rails::Application
    config.enable_dependency_loading = true
    config.autoload_paths += %W[#{Rails.root}/lib]
    
    config.load_defaults 5.2
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :zh
    config.encoding = 'utf-8'

    config.generators do |generator|
      generator.assets false
      generator.test_framework false
      generator.skip_routes true
    end
  end
end
