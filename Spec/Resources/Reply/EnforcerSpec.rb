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
    user = OpenStruct.new id: 8
    replier = OpenStruct.new id: 9
    other = OpenStruct.new id: 10

    it 'allow any actor to post new reply' do
      status = OpenStruct.new(id: 2, author: user)
      reply = OpenStruct.new(id: 1, status_id: 2, author:replier)
      enforcer = Reply::Enforcer.new(status, reply)
      enforcer.authorize(user, 'create').must_equal true
    end


    it 'raise unless the actor is the same as the user when delete' do
      status = OpenStruct.new(author:user, id: 2)
      reply = OpenStruct.new(id: 1, status_id: 2, author:replier)
      enforcer = Reply::Enforcer.new(status, reply)
      lambda {enforcer.authorize(other, 'delete')}.must_raise NotAllowed
      enforcer.authorize(replier, 'delete').must_equal true
    end

    it 'raise unless the actor is the same as the user when update' do
      user = OpenStruct.new(id: 8)
      status = OpenStruct.new(author:user, id: 2)
      reply = OpenStruct.new(id: 1, status_id: 2, author:replier)
      enforcer = Reply::Enforcer.new(status, reply)
      lambda {enforcer.authorize(other, 'update')}.must_raise NotAllowed
      enforcer.authorize(replier, 'delete').must_equal true
    end

  end


end
