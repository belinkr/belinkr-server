# encoding: utf-8
require 'minitest/autorun'
require 'json'
require 'ostruct'
require_relative '../../../Cases/EditUserProfile/Request'

include Belinkr

describe 'request model for EditUserProfile' do
  it 'prepares data objects for context' do
    entity        = OpenStruct.new(id: 1)
    actor         = OpenStruct.new(id: 2)
    actor_profile = OpenStruct.new(id: 3)

    payload   = { first: 'changed', mobile: 'changed' }
    payload   = JSON.parse(payload.to_json)
    arguments = { payload: payload, actor: actor, entity: entity }

    arguments.merge!(actor_profile: actor_profile)
    data      = EditUserProfile::Request.new(arguments).prepare

    data.fetch(:actor)                            .must_equal actor
    data.fetch(:user)                             .must_equal actor
    data.fetch(:user_changes).fetch('first')      .must_equal 'changed'
    data.fetch(:profile)                          .must_equal actor_profile
    data.fetch(:profile_changes).fetch('mobile')  .must_equal 'changed'
    data.fetch(:enforcer)                       
      .must_be_instance_of User::Enforcer
  end
end # request model for EditUserProfile

