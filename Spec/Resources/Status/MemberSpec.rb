# encoding: utf-8
require 'minitest/autorun'
require 'json'
require_relative '../../../Config'
require_relative '../../../Locales/Loader'
require_relative '../../../Resources/Status/Member'
require_relative '../../../Resources/User/Member'
require_relative '../../../Resources/Polymorphic/Polymorphic'

include Belinkr

describe Status::Member do
  describe 'validations' do
    describe 'text' do
      it 'is at least 1 character long' do
        status = Status::Member.new(text: '')
        status.valid?.must_equal false
        status.errors[:text]
          .must_include 'text must be between 1 and 10000 characters long'
      end

      it 'has less than 5000 characters' do
        status = Status::Member.new(text: 'a' * 10001)
        status.valid?.must_equal false
        status.errors[:text]
          .must_include 'text must be between 1 and 10000 characters long'
      end
    end #text

    describe 'files' do
      it 'is an Array' do
        status = Status::Member.new
        status.valid?.must_equal false
        status.files.must_be_kind_of Enumerable
        status.files.must_be_empty
      end
    end #files

    describe 'author' do
      it 'must be present' do
        status = Status::Member.new
        status.valid?.must_equal false
        status.errors[:author].must_include 'author must not be blank'
      end
    end #author
  end # validations

  describe '#author' do
    it 'returns a polymorphic object that proxies a User' do
      status = Status::Member.new
      status.author = status.scope = User::Member.new(id: 1, first: 'John', last: 'Doe')
      status.author.name.must_equal 'John Doe'

      json = status.to_json
      status = Status::Member.new JSON.parse(status.to_json)
      status.author.name.must_equal 'John Doe'
    end
  end #author

  describe '#forwarder' do
    it 'returns a polymorphic object that proxies a User' do
      status = Status::Member.new
      status.forwarder = status.author = status.scope =
        User::Member.new(id: 1, first: 'John', last: 'Doe')
      status.forwarder.name.must_equal 'John Doe'

      status = Status::Member.new JSON.parse(status.to_json)
      status.forwarder.name.must_equal 'John Doe'
    end
  end #forwarder

  describe '#replies' do
    it 'returns a set' do
      status = Status::Member.new
      status.replies.class.must_equal Set
    end
  end #replies
end # Status::Member

