# encoding: utf-8
require 'json'
require 'uuidtools'
require_relative './Exceptions'
require_relative './MasterCollection'

module Tinto
  class Member
    include Tinto::Exceptions

    NO_SCORE_VALUE = -1.0
    INTERFACE      = %w{ verify to_hash == score to_json fetch
                         sync update delete undelete destroy sanitize 
                         deleted? }

    def initialize(resource, context=nil)
      @resource             = resource
      @context              = context
      @resource.id          ||= UUIDTools::UUID.timestamp_create.to_s
      @resource.created_at  ||= Time.now
      @resource.updated_at  ||= Time.now
    end #initialize

    def verify
      raise InvalidMember unless validated? && identified?
      @resource
    end #verify

    def attributes
      @resource.attributes
    end #attributes

    alias_method :to_hash, :attributes

    def ==(other)
      attributes.to_s == other.attributes.to_s
    end #==

    def score
      (@resource.updated_at || NO_SCORE_VALUE).to_f
    end #score

    def to_json(*args)
      attributes.to_json(*args)
    end #to_json

    def fetch
      @resource.attributes = JSON.parse($redis.get storage_key)
      @resource
    rescue TypeError
      raise NotFound
    end

    def sync
      verify
      $redis.multi do
        $redis.set storage_key, self.to_json
        master_collection.add(@resource).sync
      end
      @resource
    end

    def update(attributes={})
      whitelist(attributes).each { |k, v| @resource.send :"#{k}=", v }
      @resource.updated_at = Time.now
      @resource
    end

    def delete
      verify
      @resource.deleted_at = Time.now
      @resource
    end #delete

    def undelete
      verify
      raise InvalidMember unless @resource.deleted_at.respond_to? :utc
      @resource.deleted_at = nil
      @resource
    end

    def destroy
      $redis.multi do
        $redis.del storage_key
        master_collection.delete(@resource).sync
      end if $redis
      @resource.attributes.keys.each { |k| @resource.send :"#{k}=", nil }
      @resource
    end

    def sanitize
      @resource
    end #sanitize

    def deleted?
      !!@resource.deleted_at
    end

    def whitelist(attributes={})
      return attributes unless @resource.class.const_defined?(:'WHITELIST')
      whitelist = @resource.class.const_get(:'WHITELIST')
      attributes.select { |k, v| [k, v] if whitelist.include? k.to_s }
    end

    private

    def validated?
      return @resource.valid?(@context) if @context
      return @resource.valid?
    end #validated?

    def identified?
      UUIDTools::UUID.parse(@resource.id).valid?
    end

    def storage_key
      "#{@resource.storage_key}:#{@resource.id}"
    end

    def master_collection
      MasterCollection.new @resource.storage_key
    end
  end # Member
end # Tinto
