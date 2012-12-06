# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../Services/Timeliner'

include Belinkr

describe Timeliner do
  before { @timeliner = Timeliner.new }

  describe '#timelines_for' do
    it 'returns an array of timelines for a status in this context' do
      kinds   = %w{ own general files }
      context = OpenStruct.new(timeline_kinds: kinds)
      status  = OpenStruct.new(files?: ['1'])
      
      @timeliner.timelines_for(context, status).map do |timeline|
        timeline    .must_be_instance_of Status::Collection
        kinds       .must_include timeline.kind
      end
    end
  end #timelines_for

  describe '#follower_timelines_for' do
    it 'returns an array of follower timelines for a status in this context' do
      kinds     = %w{ own general }
      follower  = OpenStruct.new(follower_timeline_kinds: kinds)
      context   = OpenStruct.new
      followers = [follower, follower]
      
      @timeliner.follower_timelines_for(followers, context).map do |timeline|
        timeline          .must_be_instance_of Status::Collection
        timeline.context  .must_equa context
        kinds             .must_include timeline.kind
      end
    end
  end #follower_timelines_for
end # Belinkr::Timeliner

