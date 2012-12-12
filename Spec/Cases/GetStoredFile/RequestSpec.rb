# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require 'redis'
require_relative '../../../Cases/GetStoredFile/Request'

$redis ||= Redis.new
$redis.select 8

include Belinkr

CarrierWave.root = Belinkr::Config::STORAGE_ROOT

describe GetStoredFile::Request do
  it 'prepares a stored_file_path data object for context' do
    actor       = OpenStruct.new
    stored_file = StoredFile::Member.new(
      { mime_type: 'text/plain', original_filename: 'foo.text' },
      File.open(File.join(File.dirname(__FILE__), '../../Support/foo.txt'))
    ).sync

    payload = { 'stored_file_id' => stored_file.id }
    data    = GetStoredFile::Request.new(payload, actor).prepare

    data.fetch(:stored_file_path).must_match /#{stored_file.id}/
  end

  it 'prepares a http_options data object for context' do
    actor       = OpenStruct.new
    stored_file = StoredFile::Member.new(
      { mime_type: 'text/plain', original_filename: 'foo.text' },
      File.open(File.join(File.dirname(__FILE__), '../../Support/foo.txt'))
    ).sync

    payload = { 'stored_file_id' => stored_file.id }
    data    = GetStoredFile::Request.new(payload, actor).prepare

    data.fetch(:http_options).wont_include :disposition
    data.fetch(:http_options).must_include :filename

    payload = { 'stored_file_id' => stored_file.id, 'inline' => true }
    data    = GetStoredFile::Request.new(payload, actor).prepare

    data.fetch(:http_options).must_include :disposition
    data.fetch(:http_options).wont_include :filename
  end
end # GetStoredFile::Request

