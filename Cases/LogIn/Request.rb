# encoding: utf-8
require_relative '../../Data/User/Member'
require_relative '../../Data/Session/Member'
require_relative '../../Data/Session/Collection'
require_relative '../../Services/Locator'

module Belinkr
  module LogIn
    class Request
      def initialize(payload)
        @payload = payload
      end #initialize
        
      def prepare
        email     = payload.fetch('email')
        plaintext = payload.fetch('password')
        remember  = payload.fetch('remember', false)
        user_id   = User::Locator.new.id_for(email)

        { 
          actor:      User::Member.new(id: user_id).fetch,
          plaintext:  plaintext,
          session:    Session::Member.new,
          sessions:   Session::Collection.new
        }
      end #prepare

      private

      attr_reader :payload
    end # Request
  end # LogIn
end # Belinkr

