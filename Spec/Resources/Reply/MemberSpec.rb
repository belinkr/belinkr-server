# encoding: utf-8
require 'minitest/autorun'
require 'json'
require_relative '../../../Locales/Loader'
require_relative '../../../Resources/Reply/Member'
require_relative '../../../Resources/User/Member'

include Belinkr

describe Reply::Member do
  describe  'validations' do
    describe 'text' do
      it 'is at least 1 character long' do
        reply =Reply::Member.new(text: '')
        reply.valid?.must_equal false
        reply.errors[:text]
          .must_include 'text must be between 1 and 10000 characters long'
      end

      it 'has less than 5000 characters' do
        reply = Reply::Member.new(text: 'a' * 10001)
        reply.valid?.must_equal false
        reply.errors[:text]
          .must_include 'text must be between 1 and 10000 characters long'
      end
    end #text

    describe 'files' do
      it 'is an Array' do
        reply = Reply::Member.new
        reply.valid?.must_equal false
        reply.files.must_be_kind_of Enumerable
        reply.files.must_be_empty
      end
    end #files

    describe 'author' do
      it 'must be present' do
        reply = Reply::Member.new
        reply.valid?.must_equal false
        reply.errors[:author].must_include 'author must not be blank'
      end
    end #author

    describe 'status_id' do
      it 'must be present' do
        reply = Reply::Member.new
        reply.valid?.must_equal false
        reply.errors[:status_id].must_include 'status must not be blank'
      end
    end #author

  end # validations

  describe '#author' do
    it 'returns a polymorphic object that proxies a User' do
      reply = Reply::Member.new
      reply.author = User::Member.new(id: 1, first: 'John', last: 'Doe')
      reply.author.name.must_equal 'John Doe'

      json = reply.to_json
      reply = Reply::Member.new JSON.parse(reply.to_json)
      reply.author.name.must_equal 'John Doe'
    end
  end #author

  describe '#storage_key' do
    it 'must get from status storage_key' do
      user = User::Member.new
      status = Status::Member.new
      status.scope = user
      reply = Reply::Member.new(status_id:status.id)
      reply.instance_variable_set :@status, status

      reply.storage_key
        .must_equal "users:#{user.id}:statuses:#{status.id}:replies"
    end
  end

end
