# encoding: utf-8
require_relative './Exceptions'
require_relative './Set/MemoryBackend'
require_relative './Set/RedisBackend'

module Tinto
  class Set
    include Enumerable
    include Tinto::Exceptions

    INTERFACE = %w{ verify in_memory? sync synced? page fetch reset each size
                    length empty? exists? include? first add merge delete
                    clear first }

    def initialize(collection)
      @collection       = collection
      @buffered_set     = MemoryBackend.new
      @persisted_set    = RedisBackend.new @collection.storage_key
      @current_backend  = @persisted_set
      @backlog          = []
    end #initialize

    def storage_key
      @persisted_set.storage_key
    end #storage_key

    def verify
      raise InvalidCollection unless @collection.valid?
    end #verify

    def in_memory?
      verify
      @current_backend == @buffered_set
    end #in_memory?

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

    def page(page_number=0, per_page=20)
      verify
      fetch

      page_number, per_page = page_number.to_i, per_page.to_i
      from = page_number * per_page
      to   = from + per_page - 1

      elements          = @buffered_set.to_a.slice(from..to)
      @buffered_set.clear.merge elements
      @current_backend  = @buffered_set
      @collection
    end #page

    def fetch
      verify
      @backlog.clear
      @buffered_set.clear
      @buffered_set.merge @persisted_set.fetch
      @current_backend  = @buffered_set
      @collection
    end #fetch

    def reset(members=[])
      verify
      @backlog.clear
      @current_backend  = @buffered_set
      clear
      merge members
      @collection
    end #reset

    def each
      verify
      fetch unless in_memory?
      return Enumerator.new(self, :each) unless block_given?
      @buffered_set.each do |id| 
        yield @collection.instantiate_member(id: id)
      end
    end #each

    def size
      verify
      @current_backend.size
    end #size

    alias_method :length, :size

    def empty?
      !(size.to_i > 0)
    end #empty?

    def include?(member)
      verify
      @current_backend.include? member.id.to_s
    end

    def first
      verify
      @collection.instantiate_member(id: @current_backend.first)
    end

    def add(member)
      verify
      member.verify
      member_id = member.id.to_s
      @buffered_set.add member_id
      @backlog.push(lambda { @persisted_set.add member_id })
      @collection
    end #add

    def merge(members)
      verify
      member_ids = members.map { |member|
        member.verify
        member.id.to_s
      }
      @buffered_set.merge member_ids
      @backlog.push(lambda { @persisted_set.merge member_ids })
      @collection
    end #merge

    def delete(member)
      verify
      member.verify
      member_id = member.id.to_s
      @buffered_set.delete member_id
      @backlog.push(lambda { @persisted_set.delete member_id })
      @collection
    end #delete

    def clear
      verify
      @buffered_set.clear
      @backlog.push(lambda { @persisted_set.clear })
      @collection
    end #clear

    def |(enumerable_or_redis_backed_set)
      @current_backend | enumerable_or_redis_backed_set
    end

    alias_method :union, :|

  end # Set
end # Tinto
