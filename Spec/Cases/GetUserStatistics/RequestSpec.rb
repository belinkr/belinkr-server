# encoding utf-8
require 'minitest/autorun'
require 'redis'
require 'ostruct'
require 'uuidtools'
require 'Tinto/Exceptions'
require_relative '../../../Cases/GetUserStatistics/Request'
require_relative '../../Factories/User'
require_relative '../../Factories/Profile'
require_relative '../../Factories/Entity'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe 'request model for GetUserStatistics' do
  describe 'prepare data objects for user statistics' do
    before do
      @user, @entity = get_user_and_entity
    end

    it 'returns a user' do
      payload   = {'user_id' => @user.id }
      arguments = { payload: payload, actor: @user, entity: @entity }

      data      = GetUserStatistics::Request.new(arguments).prepare

      data.fetch(:enforcer)   .must_be_instance_of User::Enforcer
      data.fetch(:user)     .must_be_instance_of User::Member
      #data.fetch(:actor)      .must_equal @actor
      #data.fetch(:user)      .must_equal @user
    end

  end # prepare data objects for user statistics

  def get_user_and_entity
    entity                      = Factory.entity
    user, user_profile        = factory(entity)
    [user, entity]
  end #get_user_and_entity

  def factory(entity)
    user             = Factory.user(profiles: [])
    user_profile     = Factory.profile(
                          user_id:     user.id,
                          entity_id:    entity.id
                        ).sync
    user.profiles << user_profile
    user.sync
    [user, user_profile]
  end
end # request model for GetStatus

