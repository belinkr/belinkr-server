require_relative '../../Resources/Reply/Member'
require_relative '../../Resources/Reply/Enforcer'
module Belinkr
  module CreateReply
    class Request
      def initialize(arguments)
        @payload    = arguments.fetch(:payload)
        @actor      = arguments.fetch(:actor)
        @entity     = arguments.fetch(:entity)
      end

      def prepare
        {
          enforcer:   enforcer,
          actor:      actor,
          status:     status,
          reply:      reply,
        }
      end
      private

      attr_reader :payload, :actor, :entity, :reply

      def status
        Status::Member.new(id: payload.fetch(:status_id))
      end

      def reply
        Reply::Member.new(text: payload.fetch(:text))

      end

      def enforcer
        Reply::Enforcer.new(actor, reply)
      end


    end
  end
end

