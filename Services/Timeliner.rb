# encoding: utf-8
require_relative '../Resources/Status/Collection'

module Belinkr
  class Timeliner
    def initialize(timeline_klass=Status::Collection)
      @timeline_klass = timeline_klass
    end #initialize

    def timelines_for(status)
      []
      #resource_timelines_for(resource, kinds) +
      #member_timelines_for(members, kinds)
    end #timelines

    private

    attr_reader :timeline_klass

    def resource_timelines_for(resource, kinds)
      @resource_timelines ||= 
        applicable_resource_kinds_for(kinds).map do |kind|
          timeline_klass.new(kind: kind, scope: resource)
        end
    end #resource_timelines

    def member_timelines_for(members, kinds)
      @member_timelines ||= members.flat_map do |member|
        applicable_member_kinds_for(kinds).map do |kind| 
          timeline_klass.new(kind: kind, scope: member)
        end
      end
    end #member_timelines

    def applicable_resource_kinds_for(kinds)
      @applicable_resource_kinds ||= 
        kinds.select { |kind| applicable_for?(status, kind) }
    end #applicable_resource_kinds

    def applicable_member_kinds_for(kinds)
      @member_kinds ||= 
        kinds.select { |kind| applicable_for?(status, kind) }
    end #applicable_member_kinds

    def applicable_for?(status, kind)
      !(kind == 'files' && status.files?)
    end #applicable_for?

      #scrapbook
      RESOURCE_TIMELINES  = %w{ general files }
        timeliner.resource_timelines_for(resource, RESOURCE_TIMELINES)

      #workspace
      RESOURCE_TIMELINES  = %w{ general files }
      MEMBER_TIMELINES    = %w{ workspaces files }


      def members
        tracker.users_for(resource, :member)
      end #members

      #user
      RESOURCE_TIMELINES  = %w{ own general files }
      MEMBER_TIMELINES    = %w{ general files }

      def members
        Follower::Collection.new(
          user_id:    actor.id,
          entity_id:  entity.id
        )
      end #members
  end # Timeliner
end # Belinkr

