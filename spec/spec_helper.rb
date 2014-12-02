$:.unshift File.dirname(__FILE__) + '/../lib'

require "bundler/setup"
require "nordea/file_transfer"
require "vcr"
require "simplecov"
require "awesome_print"

SimpleCov.start do
  add_filter '/vendor/bundle/'
end

VCR.configure do |c|
  c.cassette_library_dir = "spec/cassettes"
  c.hook_into :fakeweb
  c.ignore_localhost = true
  c.default_cassette_options = { :record => :new_episodes }
end

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.extend VCR::RSpec::Macros
end

Savon.configure do |config|
  config.pretty_print_xml = true
end

Nordea::FileTransfer.configure do |config|
  config.language = "EN"
  config.environment = "PRODUCTION"
  config.user_agent = "Ruby"
  config.software_id = "Ruby"
end
