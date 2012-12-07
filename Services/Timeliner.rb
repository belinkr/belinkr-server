# encoding: utf-8
require_relative '../Resources/Status/Collection'

module Belinkr
  class Timeliner
    def initialize(status, timeline_klass=Status::Collection)
      @status         = status
      @timeline_klass = timeline_klass
    end #initialize

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
    
    private

    attr_reader :status, :timeline_klass

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
  end # Timeliner
end # Belinkr

