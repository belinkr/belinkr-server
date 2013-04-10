# encoding utf-8
require 'minitest/autorun'
require 'redis'
require 'ostruct'
require_relative '../../../Cases/CreateReply/Request'

$redis ||= Redis.new
$redis.select 8

include Belinkr


describe 'request model for CreateReply' do

  describe 'prepare data' do
    before do
      @entity = OpenStruct.new(id:1)
      @actor = OpenStruct.new(id:2)
      @payload   = { :'status_id' => 5, :'text' => 'test reply' }
      arguments = { payload: @payload, actor: @actor, entity: @entity }
      @data = CreateReply::Request.new(arguments).prepare
    end

    it "returns a request model include enforcer, actor, reply and status" do
      @data.keys.must_include :status
      @data.keys.must_include :reply
      @data.keys.must_include :actor
      @data.keys.must_include :enforcer
    end

    it "returns Reply enforcer" do
      @data.fetch(:enforcer).must_be_instance_of Reply::Enforcer
    end

    it "returns a Status Member" do
      @data.fetch(:status).must_be_instance_of Status::Member
    end

    it "returns a Reply Member" do
      @data.fetch(:reply).must_be_instance_of Reply::Member
    end

    it "returns an actor passed by argument" do
      @data.fetch(:actor).must_equal @actor
    end

  end

end


