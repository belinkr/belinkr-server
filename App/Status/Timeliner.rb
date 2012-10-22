# encoding: utf-8
require_relative 'collection'
require_relative '../follower/collection'

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
      @context.class.const_get('TIMELINE_KINDS')
        .delete_if { |kind| kind == 'files' && status.files.empty? }
        .map { |kind| Status::Collection.new(kind: kind, context: @context) }
        .each { |timeline| closure.call timeline }

      @followers.each do |context|
        %w{ general files }
          .map { |kind| Status::Collection.new(kind: kind, context: context) }
          .each { |timeline| closure.call timeline }
      end

      @to_sync[*timelines]
    end #sync 
  end # UpdateTimelines
end # Belinkr
