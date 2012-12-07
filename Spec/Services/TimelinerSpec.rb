# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../Services/Timeliner'

include Belinkr

describe Timeliner do
  describe 'timelines_for' do
    it 'returns an array of resource timelines for a status in this scope' do
      scope   = OpenStruct.new(
                  resource_timelines: %w{ workspaces files },
                  follower_timelines: %w{ general files },
                  followers: [OpenStruct.new, OpenStruct.new]
                )

      status    = OpenStruct.new
      timelines = Timeliner.new(status).timelines_for(scope)

      timelines.map do |timeline|
        timeline.must_be_instance_of Status::Collection
      end

      timelines.map(&:kind).must_include 'workspaces'
      timelines.map(&:kind).must_include 'general'
      timelines.map(&:kind).wont_include 'files'
    end

    it 'includes files timelines if status has files' do
      scope   = OpenStruct.new(
                  resource_timelines: %w{ workspaces files },
                  follower_timelines: %w{ general files },
                  followers: [OpenStruct.new, OpenStruct.new]
                )

      status    = OpenStruct.new(files?: true)
      timelines = Timeliner.new(status).timelines_for(scope)

      timelines.map(&:kind).must_include 'files'
    end
  end #timelines_for
end # Belinkr::Timeliner

