# encoding: utf-8
require_relative '../Status/Collection'
require_relative '../../Tinto/Context'

module Belinkr
  class UpdateTimelines
    include Tinto::Context

    def initialize(actor, status, context, followers=[])
      @actor      = actor
      @status     = status
      @context    = context
      @followers  = followers
    end

    def call
      timelines = timelines_for(@context) + follower_timelines_for(@followers)
      timelines.each { |timeline| yield timeline if block_given? }

      @to_sync = [*timelines]
    end #call

    private

    def timelines_for(context)
      context.class.const_get('TIMELINES')
        .delete_if { |kind| kind == 'files' && @status.files.empty? }
        .map { |kind| Status::Collection.new(kind: kind, context: @context) }
    end

    def follower_timelines_for(followers)
      followers.each do |context|
        context.class.const_get('FOLLOWER_TIMELINES')
          .map { |kind| Status::Collection.new(kind: kind, context: context) }
      end
    end
  end # UpdateTimelines
end # Belinkr
