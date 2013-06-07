# encoding: utf-8
require_relative '../Resources/Status/Collection'

module Belinkr
  class Timeliner
    def initialize(status, timeline_klass=Status::Collection)
      @status         = status
      @timeline_klass = timeline_klass
    end #initialize

    def timelines_for(scope)
      resource_timelines_for(scope.resource, scope.resource_timelines) +
      follower_timelines_for(scope.followers, scope.follower_timelines)
    end #timelines

    private

    attr_reader :timeline_klass, :status

    def resource_timelines_for(resource, kinds)
      @resource_timelines ||=
        applicable_resource_kinds_for(kinds).map do |kind|
          timeline_klass.new(kind: kind, scope: resource)
        end
    end #resource_timelines

    def follower_timelines_for(followers, kinds)
      @follower_timelines ||= followers.flat_map do |follower|
        applicable_follower_kinds_for(kinds).map do |kind|
          timeline_klass.new(kind: kind, scope: follower)
        end
      end
    end #follower_timelines

    def applicable_resource_kinds_for(kinds)
      @applicable_resource_kinds ||=
        kinds.select { |kind| applicable_for?(status, kind) }
    end #applicable_resource_kinds

    def applicable_follower_kinds_for(kinds)
      @applicable_follower_kinds ||=
        kinds.select { |kind| applicable_for?(status, kind) }
    end #applicable_follower_kinds

    def applicable_for?(status, kind)
      return true unless kind == 'files'
      return true if (kind == 'files' && status.files?)
    end #applicable_for?
  end # Timeliner
end # Belinkr

