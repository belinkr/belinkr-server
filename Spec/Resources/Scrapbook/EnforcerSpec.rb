# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../../Resources/Scrapbook/Enforcer'
require 'Tinto/Exceptions'

include Belinkr
include Tinto::Exceptions

describe Scrapbook::Enforcer do
  describe '#initialize' do
    it 'requires an scrapbook' do
      lambda { Scrapbook::Enforcer.new }.must_raise ArgumentError
      Scrapbook::Enforcer.new(OpenStruct.new)
    end
  end #initialize

  describe '#authorize' do
    it 'raises unless the actor is the same as the inviter' do
      scrapbook = OpenStruct.new(inviter_id: 8)
      enforcer  = Scrapbook::Enforcer.new(scrapbook)

      lambda { enforcer.authorize(OpenStruct.new(id: 5), 'update') }
        .must_raise NotAllowed
      enforcer.authorize(OpenStruct.new(id: 8), 'update').must_equal true
    end #authorize
  end #authorize
end # Scrapbook::Enforcer

