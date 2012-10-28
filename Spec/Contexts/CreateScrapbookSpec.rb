# encoding: utf-8
require 'minitest/autorun'
require_relative '../../App/Contexts/CreateScrapbook'
require_relative '../../App/Scrapbook/Collection'
require_relative '../Factories/Scrapbook'
require_relative '../Factories/User'

include Belinkr

describe 'create scrapbook' do
  before do
    @actor      = Factory.user
    @scrapbook  = Scrapbook::Member.new(name: 'scrapbook 1')
    @scrapbooks = Scrapbook::Collection.new(user_id: @actor.id, kind: 'own')
  end

  it 'adds the scrapbook to the own scrapbook collection of the user' do
    @scrapbooks.reset
    @scrapbooks.wont_include @scrapbook
    CreateScrapbook.new(@actor, @scrapbook, @scrapbooks).call
    @scrapbooks.must_include @scrapbook
  end
end # create scrapbook

