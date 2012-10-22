# encoding: utf-8

module Tinto
  module Context
    def sync
      $redis.multi { @to_sync.each { |resource| resource.sync } }
    end # sync
  end # Context
end # Tinto
