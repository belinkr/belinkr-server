# encoding: utf-8
require 'minitest/autorun'
require_relative '../../../Resources/Session/Member'
require_relative '../../../Cases/LogOut/Request'

include Belinkr

describe 'log out request model' do
  it 'returns data for the LogOut context' do
    session = Session::Member.new
    data    = LogOut::Request.new(session).prepare

    data.fetch(:session)      .must_equal session
    data.fetch(:sessions)     .must_be_instance_of Session::Collection
  end
end

