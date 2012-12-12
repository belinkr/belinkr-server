
# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../../Cases/DeleteStoredFile/Context'

include Belinkr

describe DeleteStoredFile::Context do
  it 'deletes the stored file' do
    stored_file = Minitest::Mock.new
    context     = DeleteStoredFile::Context.new(stored_file: stored_file)

    stored_file.expect :delete, stored_file
    context.call
    stored_file.verify
  end

  it 'will sync the stored_file' do
    stored_file = OpenStruct.new
    context     = DeleteStoredFile::Context.new(stored_file: stored_file)

    context.call
    context.syncables.must_include stored_file
  end
end # StoreFile::Context

