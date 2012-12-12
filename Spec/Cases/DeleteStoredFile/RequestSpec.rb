# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require 'redis'
require_relative '../../../Cases/DeleteStoredFile/Request'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe DeleteStoredFile::Request do
  it 'prepares data objects for context' do
    actor       = OpenStruct.new
    stored_file = StoredFile::Member.new(
      { mime_type: 'text/plain', original_filename: 'foo.text' },
      File.open(File.join(File.dirname(__FILE__), '../../Support/foo.txt'))
    ).sync

    payload = { 'stored_file_id' => stored_file.id }
    data    = DeleteStoredFile::Request.new(payload, actor).prepare

    data.fetch(:stored_file).must_be_instance_of StoredFile::Member
  end
end # DeleteStoredFile::Request

