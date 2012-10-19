# encoding: utf-8
require 'json'
require 'redis'
require_relative 'Exceptions'
require_relative 'IndexScheduler'

module Tinto
  class Member
    include Exceptions

    attr_accessor :resource

    def initialize(resource, retrieve=true)
      @resource = resource
      read if @resource.id && retrieve
    end
    
    def ==(other)
      @resource.attributes == other.attributes
    end

    def score
      @resource.updated_at ? @resource.updated_at.to_f : 0
    end

    def to_json(*args)
      @resource.attributes.to_hash.dup.to_json
    end

    def read
      raise NotFound unless json_data = $redis.get(id_key)
      @resource.attributes = JSON.parse(json_data)
      @resource
    end

    def save(context=nil)
      raise InvalidResource unless valid?(@resource, context)
      this_moment             = Time.now.utc
      @resource.id          ||= next_id     
      @resource.created_at  ||= this_moment 
      @resource.updated_at    = this_moment

      persist
      @resource
    end

    def update(other, context=nil)
      other.attributes.each do |k, v| 
        @resource.send(:"#{k}=", v) if v && v.is_a?(Enumerable) && !v.empty? 
        @resource.send(:"#{k}=", v) if v && !v.is_a?(Enumerable)
      end
      @resource.save(context)
    end

    def delete(context=nil)
      raise InvalidResource unless 
        valid?(@resource, context) && @resource.created_at

      @resource.deleted_at  ||= Time.now
      persist
      @resource
    end

    def undelete(context=nil)
      raise InvalidResource unless 
        valid?(@resource, context) && @resource.deleted_at

      @resource.deleted_at = nil
      persist
      @resource
    end

    def destroy(context=nil)
      raise InvalidResource unless 
        valid?(@resource, context) && @resource.deleted_at

      $redis.del id_key
      $redis.srem master_key, @resource.id
      @resource.id = nil
      @resource
    end

    def sanitize
      if (whitelist = @resource.class.const_get "WHITELIST")
        @resource.attributes.each do |k, v|
          @resource.send(:"#{k}=", nil) unless whitelist.include?(k.to_s)
        end
      end
      @resource
    end

    def valid?(resource, context=nil)
      @resource.valid? && valid_in?(context)
    end

    private

    def valid_in?(context=nil)
      return true unless context
      @resource.valid?(context)
    end

    def persist
      $redis.set id_key, to_json
      $redis.sadd master_key, @resource.id
      IndexScheduler.new(@resource).schedule if indexable?
    end

    def id_key
      "#{resource.storage_key}:#{@resource.id}"
    end

    def next_id
      $redis.incr serial_key
    end

    def master_key
      "#{resource.storage_key}:master"
    end

    def serial_key
      "#{resource.storage_key}:serial"
    end

    def indexable?
      @resource.respond_to?(:index) && Presenter.determine_for(@resource)
    end
  end # Member
end # Collection
