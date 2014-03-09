ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../dummy/config/environment',  __FILE__)

require 'rspec'
require 'rspec/rails'
require 'ffaker'
require 'factory_girl'
require 'webmock/rspec'
require 'instant_api'

require 'support/database_cleaner'
require 'support/helpers'

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

FactoryGirl.definition_file_paths << File.join(File.dirname(__FILE__), 'factories')
FactoryGirl.find_definitions

RSpec.configure do |config|
  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
  config.render_views = true

  config.include RSpec::Rails::ControllerExampleGroup,
                 type: :controller,
                 example_group: {
                     file_path: config.escaped_path(%w[spec unit controllers])
                 }

  config.include(FactoryGirl::Syntax::Methods)
  config.include(Helpers)
end
