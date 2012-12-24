# encoding: utf-8
require 'minitest/autorun'
require 'json'
require 'ostruct'
require_relative '../../../Cases/InvitePersonToBelinkr/Request'

include Belinkr

describe 'request model for InvitePersonToBelinkr' do
  it 'prepares data objects for the context' do
    actor     = OpenStruct.new(id: 1)
    entity    = OpenStruct.new(id: 2)
    payload   = JSON.parse({}.to_json)
    arguments = { payload: payload, entity: entity, actor: actor}
    data      = InvitePersonToBelinkr::Request.new(arguments).prepare
    
    data.fetch(:actor).id               .must_equal actor.id
    data.fetch(:entity).id              .must_equal entity.id
    data.fetch(:invitation).inviter_id  .must_equal actor.id.to_s
    data.fetch(:invitation).entity_id   .must_equal entity.id.to_s
    data.fetch(:invitations).entity_id  .must_equal entity.id.to_s
    data.fetch(:message)      .must_be_instance_of Message::Member
  end
end # request model for InvitePersonToBelinkr
  
