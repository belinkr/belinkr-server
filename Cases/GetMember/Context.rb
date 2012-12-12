#encoding: utf-8

module Belinkr
  module GetMember
    class Context
      def initialize(arguments)
        @actor    = arguments.fetch(:actor)
        @member   = arguments.fetch(:member)
        @enforcer = arguments.fetch(:enforcer)
      end

      def call
        enforcer.authorize(actor, :read)
      end #call

      private

      attr_reader :actor, :member, :enforcer
    end # Context
  end # GetMember
end # Belinkr

