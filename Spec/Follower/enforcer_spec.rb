# encoding: utf-8
require 'ostruct'
require 'minitest/autorun'
require_relative '../factories/user'
require_relative '../../app/follower/enforcer'
require_relative '../../tinto/exceptions'

include Belinkr

describe Follower::Enforcer do
  describe 'create_by?' do
    it 'raises NotAllowed if actor not present' do
      actor, followed = Factory.user, Factory.user
      actor.id = nil

      lambda { Follower::Enforcer.authorize actor, :create, followed }
        .must_raise Tinto::Exceptions::NotAllowed
    end

    it 'raises NotAllowed if the entity of actor and followed do not match' do
      actor, followed = Factory.user, Factory.user
      actor.entity_id = nil

      lambda { Follower::Enforcer.authorize actor, :create, followed }
        .must_raise Tinto::Exceptions::NotAllowed
    end
  end #create_by?
end # Follower::Enforcer
