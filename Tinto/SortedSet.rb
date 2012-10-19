# encoding: utf-8
require 'set'
require_relative './Exceptions'

module Tinto
  class SortedSet
    include Tinto::Exceptions
    include Enumerable

    PER_PAGE          = 20
    NOT_IN_SET_SCORE  = -1.0

    def initialize(collection)
      @collection = collection
      @member_ids = ::Set.new
      @scores     = {}
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

    def page(page_number=0)
      ensure_valid(@collection)
      from = page_number * PER_PAGE
      to   = from + PER_PAGE - 1

      ($redis.zrevrange @collection.storage_key, from, to, with_scores: true )
      .each do |tuple|
        @member_ids.add tuple.first
        @scores[tuple.first] = tuple.last.to_f
      end
      @fetched = true
      self
    end #page

    def fetch
      ensure_valid(@collection)
      @member_ids = ::Set.new
      @scores     = {}
      ($redis.zrange @collection.storage_key, 0, -1, with_scores: true ).each do |tuple|
        @member_ids.add tuple.first
        @scores[tuple.first] = tuple.last.to_f
      end
      @fetched = true
      self
    end #fetch

    def reset(members=[])
      raise ArgumentError unless members.respond_to? :each
      ensure_valid(@collection)

      @backlog.push(lambda { 
        $redis.zadd @collection.storage_key, scores_for(members) 
      }) unless members.empty?

      members.each { |member| @scores[member.id.to_s] = score_for(member) }
      @member_ids = ::Set.new(members.map { |member| member.id.to_s })

      @fetched = true
      self
    end #reset

    def each
      ensure_valid(@collection)
      page unless @fetched
      return @member_ids.each unless block_given?
      @member_ids.each { |id| yield @collection.instantiate_member(id: id) }
    end #each

    def size
      ensure_valid(@collection)
      sync if !@fetched && !synced?

      return @member_ids.size if @fetched
      $redis.zcard @collection.storage_key
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

      element_id = element.id.to_s
      return @member_ids.include?(element_id) if @fetched
      $redis.sismember @collection.storage_key, element_id
    end #include?

    def add(element)
      ensure_valid(@collection)
      ensure_valid(element)

      @backlog.push(lambda { 
        $redis.zadd @collection.storage_key, score_for(element), element.id
      })
      @scores[element.id.to_s] = score_for(element)
      @member_ids.add element.id.to_s
      self
    end #add

    def delete(element)
      ensure_valid(@collection)
      ensure_valid(element)

      element_id = element.id.to_s
      @backlog.push(lambda { $redis.zrem @collection.storage_key, element_id })
      @member_ids.delete element_id
      @scores.delete element_id
      self
    end #delete

    def clear
      ensure_valid(@collection)
      @backlog.push(lambda { $redis.del @collection.storage_key })
      @member_ids.clear
      @scores.clear
      self
    end #clear

    def score(element)
      @scores.fetch(element.id.to_s, NOT_IN_SET_SCORE)
    end

    private

    def ensure_valid(resource)
      return if resource.valid?
      raise InvalidCollection if resource.respond_to?(:instantiate_member)
      raise InvalidMember
    end #ensure_valid

    def scores_for(members)
      members.flat_map { |member| [score_for(member), member.id.to_s ] }
    end #scores_for

    def score_for(member)
      member.updated_at.to_f
    end #score_for
  end # SortedSet
end # Tinto
