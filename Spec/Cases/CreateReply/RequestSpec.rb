# encoding utf-8
require_relative '../../Support/Helpers'
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
      @payload   = { 'status_id' => 5, 'text' => 'test reply', 'status_author_id'=>6 }

      @arguments = { payload: @payload, actor: @actor, entity: @entity}
      @arguments.merge! status_class: OpenStruct
      @arguments.merge! user_class: OpenStruct

    end

    it "returns a request model include enforcer, actor, reply and status" do
      @data = CreateReply::Request.new(@arguments).prepare
      @data.keys.must_include :status
      @data.keys.must_include :reply
      @data.keys.must_include :actor
      @data.keys.must_include :enforcer
    end

    it "returns Reply enforcer" do
      @data = CreateReply::Request.new(@arguments).prepare
      @data.fetch(:enforcer).must_be_instance_of Reply::Enforcer
    end

    it "returns a Reply Member" do
      @data = CreateReply::Request.new(@arguments).prepare
      @data.fetch(:reply).must_be_instance_of Reply::Member
    end

    it "returns an actor passed by argument" do
      @data = CreateReply::Request.new(@arguments).prepare
      @data.fetch(:actor).must_equal @actor
    end

  end

end


