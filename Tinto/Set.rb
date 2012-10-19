# encoding: utf-8
require 'set'
require_relative './Exceptions'

module Tinto
  class Set
    include Enumerable
    include Tinto::Exceptions

    def initialize(collection)
      @collection = collection
      @member_ids = ::Set.new
      @backlog    = []
    end #initialize

    def sync
      ensure_valid(@collection)
      $redis.pipelined { @backlog.each { |command| command.call } }
      @backlog.clear
      self
    end #sync

    def synced?
      ensure_valid(@collection)
      @backlog.empty?
    end #synced?

    def fetch
      ensure_valid(@collection)
      @member_ids = ::Set.new($redis.smembers @collection.storage_key)
      @fetched = true
      self
    end #fetch

    def reset(members=[])
      raise ArgumentError unless members.respond_to? :each
      ensure_valid(@collection)
      member_ids = members.map { |m| m.id.to_s }

      @backlog.push(
        lambda { $redis.sadd @collection.storage_key, member_ids }
      ) unless member_ids.empty?

      @member_ids = ::Set.new(member_ids)
      @fetched = true
      self
    end #reset

    def each
      ensure_valid(@collection)
      fetch unless @fetched
      return @member_ids.each unless block_given?
      @member_ids.each { |id| yield @collection.instantiate_member(id: id) }
    end #each

    def size
      ensure_valid(@collection)
      sync if !@fetched && !synced?

      return @member_ids.size if @fetched
      $redis.scard @collection.storage_key
    end #size

    alias_method :length, :size

    def empty?
      ensure_valid(@collection)
      !(size.to_i > 0)
    end #empty?

    def exists?
      !empty?
    end #exists?

    def include?(element)
      ensure_valid(@collection)
      sync if !@fetched && !synced?

      element = element.id.to_s
      return @member_ids.include?(element) if @fetched
      $redis.sismember @collection.storage_key, element
    end #include?

    def add(element)
      ensure_valid(@collection)
      ensure_valid(element)

      element = element.id.to_s
      @backlog.push(lambda { $redis.sadd @collection.storage_key, element })
      @member_ids.add element
      self
    end #add

    def delete(element)
      ensure_valid(@collection)
      ensure_valid(element)

      element = element.id.to_s
      @backlog.push(lambda { $redis.srem @collection.storage_key, element })
      @member_ids.delete element
      self
    end #delete

    def clear
      ensure_valid(@collection)
      @backlog.push(lambda { $redis.del @collection.storage_key })
      @member_ids.clear
      self
    end #clear

    private

    def ensure_valid(resource)
      return if resource.valid?
      raise InvalidCollection if resource.respond_to?(:instantiate_member)
      raise InvalidMember
    end #ensure_valid
  end # Set
end # Tinto
