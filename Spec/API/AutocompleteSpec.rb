# encoding: utf-8
require 'minitest/autorun'
require 'rack/test'
require 'json'
require_relative '../Support/Helpers'
require_relative '../../API/Autocomplete'
require 'uri'

include Belinkr
$redis ||= Redis.new
$redis.select 8

describe API do
  def app; API.new; end
  include Rack::Test::Methods
  include Spec::API::Helpers

  before { $redis.flushdb }

  describe 'GET /autocomplete/users' do
    it "returns user list matches parameter" do
      user, profile = create_user_and_profile
      query = user.first 
      
      uri = URI.escape "/autocomplete/users?q=#{query}"
      get uri, {}, session_for(profile)
      puts last_response.status
      users = JSON.parse(last_response.body)
      users.first.fetch("name").must_equal user.name
      last_response.status.must_equal 200
     
    end
  end

end
