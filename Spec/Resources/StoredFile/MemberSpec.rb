# encoding: utf-8
require 'minitest/autorun'
require_relative '../../../Resources/StoredFile/Member'
require_relative '../../../Locales/Loader'

include Belinkr

describe StoredFile::Member do
  describe 'validations' do
    describe '#mime_type' do
      it 'must be present' do
        stored_file = StoredFile::Member.new
        stored_file.valid?.must_equal false
        stored_file.errors.fetch(:mime_type)
          .must_include 'mime type must not be blank'
      end
    end #mime_type

    describe '#original_filename' do
      it 'must be present' do
        stored_file = StoredFile::Member.new
        stored_file.valid?.must_equal false
        stored_file.errors.fetch(:original_filename)
          .must_include 'original filename must not be blank'
      end
    end #original_filename
  end # validations
end # StoredFile::Member

