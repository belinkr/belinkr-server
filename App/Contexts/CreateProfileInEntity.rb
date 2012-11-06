# encoding: utf-8
require_relative '../Services/Locator'
require_relative '../../Tinto/Context'

module Belinkr
  class CreateProfileInEntity
    include Tinto::Context

    def initialize(arguments)
      @actor        = arguments.fetch(:actor)
      @profile      = arguments.fetch(:profile)
      @profiles     = arguments.fetch(:profiles)
      @entity       = arguments.fetch(:entity)
      @user_locator = arguments.fetch(:user_locator, User::Locator.new)
    end # initialize

    def call
      profile   .link_to(entity)
      actor     .register_in(user_locator)
      actor     .link_to(profile)
      profiles  .add(profile)

      will_sync actor, profile, profiles, user_locator
    end # call

    private

    attr_reader :actor, :profile, :profiles, :entity, :user_locator
  end # CreateProfileInEntity
end # Belinkr

