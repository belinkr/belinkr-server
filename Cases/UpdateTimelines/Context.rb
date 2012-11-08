# encoding: utf-8
require_relative '../../Data/Status/Collection'
require_relative '../../Tinto/Context'

module Belinkr
  module UpdateTimelines
    class Context
      include Tinto::Context

      def initialize(actor, status, context, followers=[])
        @actor      = actor
        @status     = status
        @context    = context
        @followers  = followers
      end

      def call
        timelines = timelines_for(@context) + follower_timelines_for(@followers)
        timelines.each { |timeline| yield timeline } if block_given?
        will_sync timelines

      end #call

      private

      def timelines_for(context)
        context.class.const_get('TIMELINES')
          .delete_if { |kind| not_applicable(kind) }
          .map { |kind| Status::Collection.new(kind: kind, context: @context) }
      end

      def follower_timelines_for(followers)
        followers.each do |context|
          context.class.const_get('FOLLOWER_TIMELINES')
            .map { |kind| Status::Collection.new(kind: kind, context: context) }
        end
      end

      def not_applicable(kind)
        kind == 'files' && @status.files.empty?
      end
    end # Context
  end # UpdateTimelines
end # Belinkr

