# encoding: utf-8
module Belinkr
  module Timeline
    class Collection
      include Enumerable
        KINDS = %w{ own general replies files workspaces
                    forwarded_by_you forwarded_by_others }

      def initialize(actor, status, context, closure, followers=[])
        @context  = context
        @status   = status
      end

      def each
        context.class.const_get('TIMELINE_KINDS')
          .delete_if { |kind| kind == 'files' && status.files.empty? }
          .map { |kind| Status::Collection.new(kind: kind, context: @context) }
        end
      end
    end
  end
