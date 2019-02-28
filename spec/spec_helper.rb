require "bundler/setup"
require "yclients/api"
require 'vcr'
begin
  require 'support/client_credentials'
rescue LoadError
  abort("Please, create spec/support/client_credentials.rb with real data") 
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr'
  config.hook_into :webmock
  config.configure_rspec_metadata!
# config.default_cassette_options = { record: :all }
end
