# encoding: utf-8
require_relative '../../Resources/User/Member'
require_relative '../../Resources/Session/Member'
require_relative '../../Resources/Session/Collection'
require_relative '../../Services/Locator'

module Belinkr
  module LogIn
    class Request
      def initialize(payload)
        @payload = payload
      end #initialize
        
      def prepare
        user_id   = User::Locator.new.id_for(payload.fetch 'email')

        { 
          actor:      User::Member.new(id: user_id).fetch,
          plaintext:  payload.fetch('password'),
          session:    Session::Member.new,
          sessions:   Session::Collection.new
        }
      end #prepare

      private

      attr_reader :payload
    end # Request
  end # LogIn
end # Belinkr

