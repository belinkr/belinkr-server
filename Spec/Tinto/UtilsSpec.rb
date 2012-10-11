# encoding: utf-8
require 'minitest/autorun'
require_relative '../../Tinto/Utils'

describe Tinto::Utils do
  describe '.bcrypted?' do
    it 'returns true if password is a BCrypt hash' do
      plaintext = 'changeme'
      password  = BCrypt::Password.create(plaintext)

      Tinto::Utils.bcrypted?(password).must_equal true
      Tinto::Utils.bcrypted?('plaintext').must_equal false
    end
  end # bcrypted?
end # Tinto::Utils
