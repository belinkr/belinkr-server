# encoding: utf-8
require 'bcrypt'
require_relative '../../Tinto/Exceptions'
require_relative '../Session/Member'
require_relative '../Session/Collection'
require_relative '../../Tinto/Context'

module Belinkr
  class LogIntoEntity
    include Tinto::Exceptions
    include Tinto::Context

    def initialize(actor, plaintext, session=Session::Member.new,
                    sessions=Session::Collection.new)
      @actor      = actor
      @plaintext  = plaintext
      @session    = session
      @sessions   = sessions
    end # initialize

    def call
      raise NotAllowed unless password_matches?(@actor.password, @plaintext)
      raise NotAllowed if @actor.deleted?

      @session.user_id    = @actor.id
      @session.profile_id = @actor.profiles.first.id
      @session.entity_id  = @actor.profiles.first.entity_id

      @session.verify
      @sessions.add @session

      @to_sync = [@session, @sessions]
      @session
    end # call

    private

    def password_matches?(encrypted, plaintext)
      BCrypt::Password.new(encrypted).is_password?(plaintext)
    end # password_matches?
  end # LogIntoEntity
end # Belinkr
