# encoding: utf-8
require 'minitest/autorun'
require_relative '../../App/Contexts/DeleteScrapbook'
require_relative '../../App/Contexts/CreateScrapbook'
require_relative '../../App/Scrapbook/Collection'
require_relative '../Factories/Scrapbook'
require_relative '../Factories/User'

include Belinkr

describe 'delete scrapbook' do 
  before do
    @actor      = Factory.user
    @scrapbook  = Scrapbook::Member.new(name: 'scrapbook 1')
    @scrapbooks = Scrapbook::Collection.new(user_id: @actor.id, kind: 'own')
    @scrapbooks.reset
    CreateScrapbook.new(@actor, @scrapbook, @scrapbooks).call
  end

  it 'marks the scrapbook as deleted' do
    @scrapbook.deleted_at.must_be_nil
    DeleteScrapbook.new(@actor, @scrapbook, @scrapbooks).call
    @scrapbook.deleted_at.wont_be_nil
  end

  it 'removes it from the own scrapbooks collection of the actor' do
    @scrapbooks.must_include @scrapbook
    DeleteScrapbook.new(@actor, @scrapbook, @scrapbooks).call
    @scrapbooks.wont_include @scrapbook
  end

  it 'raises NotAllowed if user is not the owner of the scrapbook' do
    lambda { DeleteScrapbook.new(Factory.user, @scrapbook, @changes).call }
      .must_raise Tinto::Exceptions::NotAllowed
  end
end # delete scrapbook

