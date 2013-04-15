require_relative '../../Resources/Status/Scope'
require_relative '../../Resources/Reply/Member'
require_relative '../../Resources/User/Member'
require_relative '../../Resources/Reply/Enforcer'
module Belinkr
  module CreateReply
    class Request
      def initialize(arguments)
        @payload    = arguments.fetch(:payload)
        @actor      = arguments.fetch(:actor)
        @entity     = arguments.fetch(:entity)
        @status_author_id = @payload.delete('user_id') || @payload.delete('status_author_id')
        @status_class = arguments.fetch(:status_class,Status::Member)
        @user_class = arguments.fetch(:user_class,User::Member)
        @status_scope_class = arguments.fetch(:status_scope_class,Status::Scope)
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

      attr_reader :payload, :actor, :entity, :status_author_id, :status_class,
        :status_scope_class, :user_class

      def status
        status_class.new(id: payload.fetch("status_id"), scope: status_scope.resource).fetch
      end

      def status_scope
        status_scope_class.new(status_payload, status_author, status_entity)
      end

      def status_payload
        payload.select {|key| key == 'workspace_id' || key == 'scrapbook_id' }
      end

      def status_author
        @status_author ||= user_class.new(id: status_author_id).fetch
      end

      def status_entity
        entity
      end

      def reply
        Reply::Member.new(payload.merge jail)
      end

      def jail
        {author: actor, status_id: payload.fetch("status_id")}
      end

      def enforcer
        Reply::Enforcer.new(actor, reply)
      end


    end
  end
end

