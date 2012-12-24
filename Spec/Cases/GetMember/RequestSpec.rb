# encoding: utf-8
require 'minitest/autorun'
require 'redis'
require 'ostruct'
require_relative '../../../Cases/GetMember/Request'
require_relative '../../Factories/User'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe 'request model for GetMember' do
  it 'prepares data objects for the context' do
    user          = Factory.user.sync
    payload       = { 'user_id' => user.id }
    actor         = double
    actor_profile = double
    entity        = double
    arguments     = { payload: payload, actor: actor, entity: entity }

    arguments.merge!(type: :user)
    data          = GetMember::Request.new(arguments).prepare

    data.fetch(:actor)    .must_equal actor
    data.fetch(:member)   .must_be_instance_of User::Member
    data.fetch(:enforcer) .must_be_instance_of User::Enforcer

  end # prepares data objects for the context

  def double
    OpenStruct.new(id: rand(0..9))
  end #double
end

