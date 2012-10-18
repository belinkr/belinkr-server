# encoding: utf-8
require 'set'
require_relative './Exceptions'

module Tinto
  class Set
    include Enumerable

    def initialize(collection, member_klass)
      @collection   = collection
      @member_klass = member_klass
      @members      = ::Set.new
      @backlog      = []
    end

    def sync
      raise_if_invalid
      $redis.pipelined { @backlog.each { |operation| operation.call } }
      @backlog.clear
      self
    end

    def synced?
      raise_if_invalid
      @backlog.empty?
    end

    def fetch
      raise_if_invalid
      @members = ::Set.new($redis.smembers @collection.storage_key)
      @fetched = true
      self
    end

    def reset(members=[])
      raise_if_invalid
      return self if members.empty?
      members = members.map { |m| m.to_s }

      @backlog.push(lambda { $redis.sadd @collection.storage_key, members })
      @members = ::Set.new(members)
      @fetched = true
      self
    end

    def each
      raise_if_invalid
      fetch unless @fetched
      return @members.each unless block_given?
      @members.each { |id| yield @member_klass.new(id: id) }
    end

    def size
      raise_if_invalid
      sync if !@fetched && !synced?
      return @members.size if @fetched
      $redis.scard @collection.storage_key
    end

    def include?(element)
      raise_if_invalid
      sync if !@fetched && !synced?

      element = element.to_s
      return @members.include?(element) if @fetched
      $redis.sismember @collection.storage_key, element
    end

    def empty?
      raise_if_invalid
      sync if !@fetched && !synced?

      return @members.empty? if @fetched
      $redis.scard(@collection.storage_key) > 0
    end

    def exists?
      !empty?
    end

    def add(element)
      raise_if_invalid
      element = element.to_s
      @backlog.push(lambda { $redis.sadd @collection.storage_key, element })
      @members.add element.to_s
      self
    end

    def delete(element)
      raise_if_invalid
      element = element.to_s
      @backlog.push(lambda { $redis.srem @collection.storage_key, element })
      @members.delete element
      self
    end

    def clear
      raise_if_invalid
      @backlog.push(lambda { $redis.del @collection.storage_key })
      @members.clear
      self
    end

    private

    def raise_if_invalid
      raise InvalidCollection unless @collection.valid?
    end
  end # Set
end # Tinto
