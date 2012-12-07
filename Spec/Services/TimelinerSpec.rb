# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../Services/Timeliner'

include Belinkr

describe Timeliner do
  describe '#resource_timelines_for' do
    it 'returns an array of resource timelines for a status in this scope' do
      kinds   = %w{ own general files }
      scope   = OpenStruct.new
      user    = OpenStruct.new
      status  = OpenStruct.new(files?: true)
      
      timeliner = Timeliner.new(status)

      timeliner.resource_timelines_for(user, kinds).map do |timeline|
        timeline    .must_be_instance_of Status::Collection
        kinds       .must_include timeline.kind
      end
    end
  end #timelines_for

  describe '#member_timelines_for' do
    it 'returns an array of member timelines for a status in this scope' do
      kinds   = %w{ own general files }
      scope   = OpenStruct.new
      user    = OpenStruct.new
      status  = OpenStruct.new(files?: true)
      
      timeliner = Timeliner.new(status)

      timeliner.member_timelines_for([user, user], kinds).map do |timeline|
        timeline    .must_be_instance_of Status::Collection
        kinds       .must_include timeline.kind
      end
    end
  end #follower_timelines_for
end # Belinkr::Timeliner

