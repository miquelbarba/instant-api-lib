ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

require 'rspec'
require 'rspec/rails'
require 'ffaker'
require 'factory_girl'
require 'webmock/rspec'
require 'instant_api'


Dir[Rails.root.join('spec/support/*.rb')].each { |f| require f }

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  config.order = 'random'
  config.render_views = true

  config.include RSpec::Rails::ControllerExampleGroup,
                 type: :controller,
                 example_group: {
                     file_path: config.escaped_path(%w[spec unit controllers])
                 }

  config.include(FactoryGirl::Syntax::Methods)
  config.include(Helpers)
end
