require 'rspec'
require 'rspec/its'

require "bundler/setup"
# require "active_support"
# require 'action_controller'
# require 'action_controller/base'
require 'rails/all'

require_relative '../lib/jasonette'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # config.mock_with :rspec do |mocks|
  #   mocks.verify_partial_doubles = true
  # end
end

Dir["./spec/support/**/*.rb"].sort.each { |f| require f }
