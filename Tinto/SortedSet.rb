# encoding: utf-8
require_relative "./Exceptions"

module Tinto
  class SortedSet
    include Enumerable

    PER_PAGE = 20

    def initialize(collection, member_class, storage_key, members=[])
      @collection   = collection 
      @member_class = member_class
      @storage_key  = storage_key
      @members      = members

      unless @collection && @storage_key && @member_class
        raise ArgumentError "collection, storage_key and member_class required"
      end
    end

    def each(&block)
      raise Tinto::Exceptions::InvalidResource unless @collection.valid?
      @members.each do |i| 
        if i.is_a? Numeric or i.is_a? String
          yield @member_class.new({ id: i }.merge! member_init_params)
        else
          yield i
        end
      end
    end

    def size
      raise Tinto::Exceptions::InvalidResource unless @collection.valid?
      $redis.zcard @storage_key
    end

    alias_method :length, :size

    def include?(member)
      raise Tinto::Exceptions::InvalidResource unless @collection.valid?
      !$redis.zscore(@storage_key, member.id).nil?
    end

    def empty?
      raise Tinto::Exceptions::InvalidResource unless @collection.valid?
      !(size > 0 if exists?)
    end

    def exists?
      raise Tinto::Exceptions::InvalidResource unless @collection.valid?
      $redis.exists @storage_key
    end

    def all
      raise Tinto::Exceptions::InvalidResource unless @collection.valid?
      @members = $redis.zrevrange(@storage_key, 0, -1)
      self
    end

    def page(number=0)
      raise Tinto::Exceptions::InvalidResource unless @collection.valid?
      per_page = @page_size || PER_PAGE
      from     = per_page * number.to_i
      to       = from + per_page - 1
      @members = $redis.zrevrange(@storage_key, from, to)
      @collection
    end

    def page_size(number=0)
      @page_size = number.to_i
      @page_size = nil      if number.to_i == 0
      @page_size = PER_PAGE if number.to_i > PER_PAGE
      self
    end

    def merge(enumerable)
      raise Tinto::Exceptions::InvalidResource unless @collection.valid?
      enumerable.each { |member| add member }
    end

    def add(member, score=nil)
      raise Tinto::Exceptions::InvalidResource unless @collection.valid?
      $redis.zadd @storage_key, (score || member.score), member.id
      self
    end

    alias_method :<<, :add

    def remove(member)
      raise Tinto::Exceptions::InvalidResource unless @collection.valid?
      $redis.zrem @storage_key, member.id
      self
    end

    def score(member, score)
      raise Tinto::Exceptions::InvalidResource unless @collection.valid?
      # PENDING: investigate how to know if we are running inside
      # a multi do..end block. If we aren't, then we should run these
      # redis methods inside a multi do..end block
      #$redis.multi do
        remove(member)
        add(member, score)
      #end
    end

    def delete
      raise Tinto::Exceptions::InvalidResource unless @collection.valid?
      $redis.del @storage_key
      self
    end

    private

    def member_init_params
      return {} unless @collection.respond_to? :member_init_params
      @collection.member_init_params
    end
  end # Collection
end # Tinto
