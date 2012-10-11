# encoding: utf-8
require 'bcrypt'
require_relative '../../Tinto/Exceptions'
require_relative '../Session/Member'
require_relative '../Session/Collection'

class LogIntoEntity
  include Tinto::Exceptions

  def initialize(actor, plaintext)
    @actor      = actor
    @plaintext  = plaintext
    @session    = Belinkr::Session::Member.new
    @sessions   = Belinkr::Session::Collection.new
  end # initialize

  def call
    raise NotAllowed unless password_matches?(@actor.password, @plaintext)

    @session.user_id    = @actor.id
    @session.profile_id = @actor.profile_ids.first
    @session.entity_id  = @actor.entity_ids.first

    @session.save
    @sessions.add @session
    @session
  end # call

  private

  def password_matches?(encrypted, plaintext)
    BCrypt::Password.new(encrypted).is_password?(plaintext)
  end # password_matches?
end # LogIntoEntity

