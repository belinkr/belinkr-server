# encoding: utf-8
require 'set'
require_relative './Exceptions'

module Tinto
  class Set
    include Enumerable
    include Tinto::Exceptions

    PER_PAGE  = 20
    INTERFACE = %w{ verify sync synced? page fetch reset each size length
                    empty? exists? include? add merge delete clear }

    def initialize(collection)
      @collection = collection
      @page       = @member_ids = ::Set.new
      @backlog    = []
    end #initialize

    def sync
      verify
      $redis.pipelined { @backlog.each { |command| command.call } }
      @backlog.clear
      @collection
    end #sync

    def synced?
      verify
      @backlog.empty?
    end #synced?

    def page(page_number=0)
      verify
      from = page_number * PER_PAGE
      to   = from + PER_PAGE - 1

      fetch
      @page = @member_ids.to_a.slice(from..to)
      @collection
    end #page

    def fetch
      verify
      @member_ids = ::Set.new($redis.smembers @collection.storage_key)
      @fetched = true
      @collection
    end #fetch

    def reset(members=[])
      verify
      raise ArgumentError unless members.respond_to? :each
      member_ids = members.map { |m| m.id.to_s }

      @backlog.push(
        lambda { $redis.sadd @collection.storage_key, member_ids }
      ) unless member_ids.empty?

      @page = @member_ids = ::Set.new(member_ids)
      @fetched = true
      @collection
    end #reset

    def each
      verify
      fetch unless @fetched
      return @page.each unless block_given?
      @page.each { |id| yield @collection.instantiate_member(id: id) }
    end #each

    def size
      verify
      sync if !@fetched && !synced?

      return @member_ids.size if @fetched
      $redis.scard @collection.storage_key
    end #size

    alias_method :length, :size

    def empty?
      verify
      !(size.to_i > 0)
    end #empty?

    def exists?
      !empty?
    end #exists?

    def include?(member)
      verify
      sync if !@fetched && !synced?

      member_id = member.id.to_s
      return @member_ids.include?(member_id) if @fetched
      $redis.sismember @collection.storage_key, member_id
    end #include?

    def add(member)
      verify
      member.verify

      member_id = member.id.to_s
      @backlog.push(lambda { $redis.sadd @collection.storage_key, member_id })
      @member_ids.add member_id
      @collection
    end #add

    def merge(enumerable)
      member_ids = enumerable.map { |member| member.id }
      @backlog.push(lambda { $redis.sadd @collection.storage_key, member_ids })
      @member_ids.merge member_ids
      @collection
    end #merge

    def delete(member)
      verify
      member.verify

      member_id = member.id.to_s
      @backlog.push(lambda { $redis.srem @collection.storage_key, member_id })
      @member_ids.delete member_id
      @collection
    end #delete

    def clear
      verify
      @backlog.push(lambda { $redis.del @collection.storage_key })
      @member_ids.clear
      @collection
    end #clear

    private

    def verify
      raise InvalidCollection unless @collection.valid?
    end #verify
  end # Set
end # Tinto
