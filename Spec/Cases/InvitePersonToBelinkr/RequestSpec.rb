# encoding: utf-8
require 'minitest/autorun'
require 'json'
require 'ostruct'
require_relative '../../../Cases/InvitePersonToBelinkr/Request'

include Belinkr

describe 'request model for InvitePersonToBelinkr' do
  it 'prepares data objects for the context' do
    actor   = OpenStruct.new(id: 1)
    entity  = OpenStruct.new(id: 2)

    payload = {}
    payload = JSON.parse(payload.to_json)
    data    = InvitePersonToBelinkr::Request
                .new(payload, actor, entity).prepare
    
    data.fetch(:actor).id     .must_equal actor.id
    data.fetch(:entity).id    .must_equal entity.id
    data.fetch(:invitation)   .must_be_instance_of Invitation::Member
    data.fetch(:invitations)  .must_be_instance_of Invitation::Collection
    data.fetch(:message)      .must_be_instance_of Message::Member
  end
end # request model for InvitePersonToBelinkr
  
