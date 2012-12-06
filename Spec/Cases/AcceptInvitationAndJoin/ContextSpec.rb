# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require 'set'
require_relative '../../../Cases/AcceptInvitationAndJoin/Context'

include Belinkr

describe 'accept invitation and join' do
  before do
    @entity       = OpenStruct.new
    @actor        = OpenStruct.new
    @profile      = OpenStruct.new
    @inviter      = OpenStruct.new
    @invitation   = OpenStruct.new
    @invitations  = Set.new
    @profiles     = Set.new
  end

  it 'marks the invitation as accepted' do
    @invitation = MiniTest::Mock.new

    context = AcceptInvitationAndJoin::Context.new(
      actor:      @actor,
      invitation: @invitation,
      entity:     @entity,
      profile:    @profile,
      profiles:   @profiles
    )
    context.create_profile_context    = OpenStruct.new
    context.register_activity_context = OpenStruct.new

    @invitation.expect :accept, @invitation
    context.call
    @invitation.verify
  end

  it 'creates a profile for the actor' do
    context = AcceptInvitationAndJoin::Context.new(
      actor:      @actor,
      invitation: @invitation,
      entity:     @entity,
      profile:    @profile,
      profiles:   @profiles
    )
    context.register_activity_context = OpenStruct.new
    context.create_profile_context    = MiniTest::Mock.new

    context.create_profile_context.expect :call, nil
    context.call
    context.create_profile_context.verify
  end

  it 'registers an activity' do
    skip
    context = AcceptInvitationAndJoin::Context.new(
      actor:      @actor,
      invitation: @invitation,
      entity:     @entity,
      profile:    @profile,
      profiles:   @profiles
    )
    context.create_profile_context    = OpenStruct.new
    context.register_activity_context = MiniTest::Mock.new

    context.register_activity_context.expect :call, nil
    context.call
    context.register_activity_context.verify
  end
end # accept invitation and join

