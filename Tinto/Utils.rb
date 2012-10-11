# encoding: utf-8
require 'bcrypt'
require 'digest'
require 'tzinfo'

module Tinto
  module Utils
    SHA256_HASH_LENGTH = 64

    def self.local_time_for(utc_time, timezone)
      TZInfo::Timezone.get(timezone)
        .utc_to_local(utc_time)
        .strftime("%Y-%m-%d %H:%M:%S")
    end

    def self.timezones
      TZInfo::Timezone.all_identifiers
    end

    def self.bcrypted?(password)
      BCrypt::Password.new(password)
      true
    rescue BCrypt::Errors::InvalidHash
      false
    end

    def self.generate_token
      Digest::SHA2.hexdigest([Time.now.to_f, rand].join)
    end

    def self.is_sha256?(text)
      return true if text && text.length == SHA256_HASH_LENGTH

      message = I18n::t('validation.errors.must_be_sha256', attribute: 'id')
      return [false, message]
    end
  end # Utils
end # Tinto
