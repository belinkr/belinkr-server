require 'minitest/autorun'
require 'minitest-documenter'
include MiniTest::Documenter
MiniTest::Documenter.configure do |config|
  config.decide_docs_dir(__FILE__)
  config.ignored_env_keys =['rack.session']
  config.transform_rack_session = true
end
module Belinkr
  class API
    use PryRescue::Rack
  end
end

