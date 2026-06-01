require_relative "boot"

require "rails/all"

# Explicitly require pagy before Bundler loads the app.
# This ensures Pagy::Backend and Pagy::Frontend are defined
# before ApplicationController and ApplicationHelper include them.
require "pagy"
require "pagy/extras/bootstrap"
require "pagy/extras/overflow"

Bundler.require(*Rails.groups)

module Blog
  class Application < Rails::Application
    config.load_defaults 7.2
    config.autoload_lib(ignore: %w[assets tasks])
  end
end
