# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../../Cases/StoreFile/Context'

include Belinkr

describe StoreFile::Context do
  it 'will sync the stored_file' do
    stored_file = OpenStruct.new
    context     = StoreFile::Context.new(stored_file: stored_file)

    context.call
    context.syncables.must_include stored_file
  end
end # StoreFile::Context

