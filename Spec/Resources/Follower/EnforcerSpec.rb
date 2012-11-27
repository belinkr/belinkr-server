# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../../Resources/Follower/Enforcer'
require 'Tinto/Exceptions'

include Belinkr
include Tinto::Exceptions

describe Follower::Enforcer do
  describe '#initialize' do
    it 'requires a followed user' do
      lambda { Follower::Enforcer.new }.must_raise ArgumentError
      Follower::Enforcer.new(OpenStruct.new)
    end
  end #initialize

  describe '#authorize' do
    it 'raises if the actor is the same as the followed user' do
      followed  = OpenStruct.new(id: 8)
      enforcer  = Follower::Enforcer.new(followed)

      lambda { enforcer.authorize(OpenStruct.new(id: 8), 'follow') }
        .must_raise NotAllowed
      enforcer.authorize(OpenStruct.new(id: 5), 'follow').must_equal true
    end #authorize
  end #authorize
end # Follower::Enforcer

