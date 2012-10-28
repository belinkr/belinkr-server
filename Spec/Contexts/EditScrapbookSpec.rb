# encoding: utf-8
require 'minitest/autorun'
require_relative '../../App/Contexts/EditScrapbook'
require_relative '../../App/Contexts/CreateScrapbook'
require_relative '../../App/Scrapbook/Collection'
require_relative '../Factories/Scrapbook'
require_relative '../Factories/User'
require_relative '../../Tinto/Exceptions'

include Belinkr

describe 'create scrapbook' do
  before do
    @actor      = Factory.user
    @scrapbook  = Scrapbook::Member.new(name: 'scrapbook 1')
    @scrapbooks = Scrapbook::Collection.new(user_id: @actor.id, kind: 'own')
    @changes    = { name: 'changed' }
    @scrapbooks.reset
    CreateScrapbook.new(@actor, @scrapbook, @scrapbooks).call
  end

  it 'applies changes to scrapbook data' do
    @scrapbook.name.must_equal 'scrapbook 1'
    EditScrapbook.new(@actor, @scrapbook, @changes).call
    @scrapbook.name.must_equal 'changed'
  end

  it 'raises NotAllowed if user is not the owner of the scrapbook' do
    lambda { EditScrapbook.new(Factory.user, @scrapbook, @changes).call }
      .must_raise Tinto::Exceptions::NotAllowed
  end
end # create scrapbook

