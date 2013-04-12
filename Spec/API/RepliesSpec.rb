# encoding: utf-8
require 'minitest/autorun'
require 'rack/test'
require 'json'
require_relative '../../API/Statuses'
require_relative '../../API/Replies'
require_relative '../Support/Helpers'
require_relative '../Factories/Entity'

include Belinkr
$redis ||= Redis.new
$redis.select 8

describe API do
  def app; API.new; end
  include Rack::Test::Methods
  include Spec::API::Helpers

  before { $redis.flushdb }

  #describe 'GET /statuses/:status_id/replies' do
  #  it "returns replies for the status" do
  #    user, profile, entity = create_user_and_profile
  #    post '/statuses', { text: 'test' }.to_json, session_for(profile)
  #    status = JSON.parse(last_response.body)
  #    post "/statuses/#{status.fetch('id')}/replies", { text: 'test reply' }.to_json,
  #      session_for(profile)
  #    last_response.status.must_equal 201
  #  end
  #end

  #describe 'GET /statuses/:status_id/replies/:id' do
  #  it "returns a reply by status id and reply id" do

  #  end
  #end

  describe 'POST /statuses/:status_id/replies' do
    it "post a new reply of the status" do
      user, profile, entity = create_user_and_profile
      user.sync
      post '/statuses', { text: 'test' }.to_json, session_for(profile)
      status = JSON.parse(last_response.body)
      post "/statuses/#{status.fetch('id')}/replies", { status_author_id: user.id, text: 'test reply' }.to_json,
        session_for(profile)
      last_response.status.must_equal 201
      reply = JSON.parse(last_response.body)
      reply['text'].must_equal 'test reply'
    end
    it "post a new reply of the status from different user in same entity" do
      user, profile, entity = create_user_and_profile
      replier, profile_replier, entity = create_user_and_profile(entity)
      user.sync
      replier.sync
      post '/statuses', { text: 'test' }.to_json, session_for(profile)
      status = JSON.parse(last_response.body)
      post "/statuses/#{status.fetch('id')}/replies", { status_author_id: user.id, text: 'test reply' }.to_json,
        session_for(profile_replier)
      last_response.status.must_equal 201
      reply = JSON.parse(last_response.body)
      reply['text'].must_equal 'test reply'
    end
  end

  #describe "PUT /statuses/:status_id/replies/:id" do
  #  it "update a reply" do

  #  end

  #end

  #describe "DELETE /statuses/:status_id/replies/:id" do
  #  it "delete a reply" do

  #  end
  #end


end
