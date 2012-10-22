# encoding: utf-8
require 'set'
require_relative './Exceptions'

module Tinto
  class SortedSet
    include Tinto::Exceptions
    include Enumerable

    PER_PAGE          = 20
    NOT_IN_SET_SCORE  = -1.0
    INTERFACE         = %w{ verify sync synced? page fetch reset each size
                            length empty? exists? include? add merge delete 
                            clear score } 
    def initialize(collection)
      @collection = collection
      @member_ids = ::Set.new
      @scores     = {}
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

      @member_ids = ::Set.new
      @scores     = {}

      ($redis.zrevrange @collection.storage_key, from, to, with_scores: true )
      .each do |tuple|
        @member_ids.add tuple.first
        @scores[tuple.first] = tuple.last.to_f
      end
      @fetched = true
      @collection
    end #page

    def fetch
      verify
      @member_ids = ::Set.new
      @scores     = {}
      ($redis.zrange @collection.storage_key, 0, -1, with_scores: true ).each do |tuple|
        @member_ids.add tuple.first
        @scores[tuple.first] = tuple.last.to_f
      end
      @fetched = true
      @collection
    end #fetch

    def reset(members=[])
      raise ArgumentError unless members.respond_to? :each
      verify

      @backlog.push(lambda { 
        $redis.zadd @collection.storage_key, scores_for(members) 
      }) unless members.empty?

      members.each { |member| @scores[member.id.to_s] = score_for(member) }
      @member_ids = ::Set.new(members.map { |member| member.id.to_s })

      @fetched = true
      @collection
    end #reset

    def each
      verify
      page unless @fetched
      return @member_ids.each unless block_given?
      @member_ids.each { |id| yield @collection.instantiate_member(id: id) }
    end #each

    def size
      verify
      sync if !@fetched && !synced?

      return @member_ids.size if @fetched
      $redis.zcard @collection.storage_key
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

      @backlog.push(lambda { 
        $redis.zadd @collection.storage_key, score_for(member), member.id
      })
      @scores[member.id.to_s] = score_for(member)
      @member_ids.add member.id.to_s
      @collection
    end #add

    def merge(enumerable)
      enumerable.each do |member|
        @scores[member.id.to_s] = score_for(member)
        @member_ids.add member.id.to_s
      end

      members_scores = enumerable.map { |member| [member.id, member.score] }
      @backlog.push(
        lambda { $redis.zadd @collection.storage_key, members_scores }
      )
      @collection
    end #merge

    def delete(member)
      verify
      member.verify

      member_id = member.id.to_s
      @backlog.push(lambda { $redis.zrem @collection.storage_key, member_id })
      @member_ids.delete member_id
      @scores.delete member_id
      @collection
    end #delete

    def clear
      verify
      @backlog.push(lambda { $redis.del @collection.storage_key })
      @member_ids.clear
      @scores.clear
      @collection
    end #clear

    def score(member)
      @scores.fetch(member.id.to_s, NOT_IN_SET_SCORE)
    end

    private

    def verify
      raise InvalidCollection unless @collection.valid?
    end #verify

    def scores_for(members)
      members.flat_map { |member| [score_for(member), member.id.to_s ] }
    end #scores_for

    def score_for(member)
      member.updated_at.to_f
    end #score_for
  end # SortedSet
end # Tinto
