# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../../Resources/Reply/Enforcer'
require 'Tinto/Exceptions'

include Belinkr
include Tinto::Exceptions

describe Reply::Enforcer do
  describe  '#initialize' do
    it 'require status and reply' do
      lambda {Reply::Enforcer.new}.must_raise ArgumentError
      Reply::Enforcer.new(OpenStruct.new, OpenStruct.new)
    end
  end

  describe 'authorize' do
    it 'raise unless the acor is the same as the user when delete' do
      user = OpenStruct.new(id: 8)
      status = OpenStruct.new(user_id: 8, id: 2)
      reply = OpenStruct.new(id: 1, status_id: 2, user_id: 8)
      enforcer = Reply::Enforcer.new(status, reply)
      lambda {enforcer.authorize(OpenStruct.new(id: 9), 'delete')}.must_raise NotAllowed
      enforcer.authorize(user, 'delete').must_equal true
    end

    it 'raise unless the acor is the same as the user when update' do
      user = OpenStruct.new(id: 8)
      status = OpenStruct.new(user_id: 8, id: 2)
      reply = OpenStruct.new(id: 1, status_id: 2, user_id: 8)
      enforcer = Reply::Enforcer.new(status, reply)
      lambda {enforcer.authorize(OpenStruct.new(id: 9), 'update')}.must_raise NotAllowed
      enforcer.authorize(user, 'delete').must_equal true
    end

  end


end
