# encoding: utf-8
require_relative './Exceptions'
require_relative './SortedSet/MemoryBackend'
require_relative './SortedSet/RedisBackend'

module Tinto
  class SortedSet
    include Tinto::Exceptions
    include Enumerable

    NOT_IN_SET_SCORE  = -1.0
    INTERFACE         = %w{ verify sync synced? page fetch reset each size
                            length empty? exists? include? add merge delete 
                            clear score } 

    def initialize(collection)
      @collection       = collection
      @buffered_zset    = MemoryBackend.new
      @persisted_zset   = RedisBackend.new @collection.storage_key
      @current_backend  = @persisted_zset
      @backlog          = []
    end #initialize

    def verify
      raise InvalidCollection unless @collection.valid?
    end #verify

    def in_memory?
      verify
      @current_backend == @buffered_zset
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

      page_number, per_page = page_number.to_i, per_page.to_i
      from = page_number * per_page
      to   = from + per_page - 1

      fetch(from, to)

      elements          = @buffered_zset.to_a
      @buffered_zset    = MemoryBackend.new
      @buffered_zset.merge elements
      @current_backend  = @buffered_zset
      @collection
    end #page

    def fetch(from=0, to=-1)
      verify
      @backlog.clear
      @buffered_zset    = MemoryBackend.new
      @buffered_zset.merge @persisted_zset.fetch(from, to)
      @current_backend  = @buffered_zset
      @collection
    end #fetch

    def reset(members=[])
      verify
      @backlog.clear
      @current_backend  = @buffered_zset
      clear
      merge members
      @collection
    end #reset

    def score(member)
      @current_backend.score(member.id.to_s) || NOT_IN_SET_SCORE
    end #score

    def each
      verify
      fetch unless in_memory?
      return Enumerator.new(self, :each) unless block_given?
      @buffered_zset.each do |score, id| 
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
      score     = score_for(member)
      @buffered_zset.add score, member_id
      @backlog.push(lambda { @persisted_zset.add score, member_id })
      @collection
    end #add

    def merge(members)
      verify
      scores_and_member_ids = scores_and_member_ids_for(members)
      @buffered_zset.merge scores_and_member_ids
      @backlog.push(lambda { @persisted_zset.merge scores_and_member_ids })
      @collection
    end #merge

    def delete(member)
      verify
      member.verify
      member_id = member.id.to_s
      @buffered_zset.delete member_id
      @backlog.push(lambda { @persisted_zset.delete member_id })
      @collection
    end #delete

    def clear
      verify
      @buffered_zset.clear
      @backlog.push(lambda { @persisted_zset.clear })
      @collection
    end #clear

    def score_for(member)
      member.updated_at.to_f
    end #score_for

    def scores_and_member_ids_for(members)
      members.map do |member|
        member.verify
        [score_for(member), member.id.to_s]
      end
    end #scores_and_member_ids_for
  end # SortedSet
end # Tinto
