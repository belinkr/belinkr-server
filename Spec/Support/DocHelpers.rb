require 'minitest/autorun'
require 'minitest-documenter'
MiniTest::Documenter.configure do |config|
  config.decide_docs_dir(__FILE__)
  config.ignored_env_keys =['rack.session']
  config.transform_rack_session = true
end

