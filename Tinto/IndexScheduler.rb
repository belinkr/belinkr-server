# encoding: utf-8
require_relative 'Presenter'

module Tinto
  class IndexScheduler
    QUEUE_KEY = 'elasticsearch'

    def initialize(resource)
      @resource = resource
    end

    def schedule
      $redis.rpush QUEUE_KEY, document
    end

    def document
      presenter_for(@resource).new(@resource).as_poro.merge(
        '_index'      => @resource.index,
        '_index_path' => @resource.index_path
      ).to_json
    end

    private

    def presenter_for(resource)
      Tinto::Presenter.determine_for(resource)
    end
  end # IndexScheduler
end # Tinto

