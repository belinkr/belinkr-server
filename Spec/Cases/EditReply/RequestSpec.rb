# encoding utf-8
require_relative '../../Support/Helpers'
require 'minitest/autorun'
require 'redis'
require 'ostruct'
require_relative '../../../Cases/EditReply/Request'

$redis ||= Redis.new
$redis.select 8

include Belinkr


describe 'request model for EditReply' do

  describe 'prepare data' do
    before do
      @entity = OpenStruct.new(id:1)
      @actor = OpenStruct.new(id:2)
      @payload   = { 'id' =>2, 'status_id' => 5, 'text' => 'test reply', 'status_author_id'=>6 }

      @arguments = { payload: @payload, actor: @actor, entity: @entity}
      class StatusStruct < OpenStruct
        def fetch
          OpenStruct.new({replies: [OpenStruct.new({id:2})]})
        end
      end
      @arguments.merge! status_class: StatusStruct
      @arguments.merge! user_class: OpenStruct

    end

    it "returns a request model include enforcer, actor, reply and status" do
      @data = EditReply::Request.new(@arguments).prepare
      @data.keys.must_include :status
      @data.keys.must_include :reply
      @data.keys.must_include :actor
      @data.keys.must_include :enforcer
    end

    it "returns Reply enforcer" do
      @data = EditReply::Request.new(@arguments).prepare
      @data.fetch(:enforcer).must_be_instance_of Reply::Enforcer
    end

    it "returns a Reply Member" do
      @data = EditReply::Request.new(@arguments).prepare
      @data.fetch(:reply).text.must_equal @payload['text']

    end

    it "returns an actor passed by argument" do
      @data = EditReply::Request.new(@arguments).prepare
      @data.fetch(:actor).must_equal @actor
    end

  end

end


