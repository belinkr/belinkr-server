# encoding: utf-8
require 'json'

module Tinto
  class Member
    NO_SCORE_VALUE = -1.0

    def initialize(member, context=nil)
      @member   = member
      @context  = context
      @member.created_at ||= Time.now
      @member.updated_at ||= Time.now
    end #initialize

    def valid?
      @member.valid?(@context)
    end

    def attributes
      @member.attributes
    end #attributes

    def ==(other)
      attributes.to_s == other.attributes.to_s
    end #==

    def score
      (@member.updated_at || NO_SCORE_VALUE).to_f
    end #score

    def to_json
      attributes.to_json
    end #to_json

    def fetch
      @member.attributes = JSON.parse($redis.get @member.storage_key)
      self
    end

    def sync
      ensure_valid(@member)
      $redis.set @member.storage_key, self.to_json
      self
    end

    def delete
      ensure_valid(@member)
      @member.deleted_at = Time.now
      self
    end #delete

    def undelete
      ensure_valid(@member)
      raise InvalidMember unless @member.deleted_at.respond_to? :utc
      @member.deleted_at = nil
      self
    end

    private

    def ensure_valid(resource)
      raise InvalidMember unless resource.valid?
    end
  end # Member
end # Tinto
