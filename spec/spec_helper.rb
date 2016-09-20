require_relative '../carmen_builds'
require_relative './helpers'
require 'factory_girl'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include Helpers
  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end


  config.before :suite do
    FactoryGirl.find_definitions
  end

  config.after :each do
    FileUtils.rm_rf(Dir["tmp/[^.]*"])
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

end
