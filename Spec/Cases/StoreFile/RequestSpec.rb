# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../../Cases/StoreFile/Request'

include Belinkr

describe StoreFile::Request do
  it 'prepares data objects for context' do
    actor   = OpenStruct.new
    payload = {
      'file' => {
        type:     'image/png',
        filename: 'logo.png',
        tempfile: File.join(File.dirname(__FILE__), '../../Support/logo.png')
      }
    }
    data = StoreFile::Request.new(payload, actor).prepare

    data.fetch(:stored_file).must_be_instance_of StoredFile::Member
    data.fetch(:stored_file).mime_type.must_equal 'image/png'
    data.fetch(:stored_file).original_filename.must_equal 'logo.png'
  end
end # StoreFile::Request

