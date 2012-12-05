# encoding: utf-8
require 'minitest/autorun'
require 'json'
require 'redis'
require_relative '../../../Cases/FollowUserInEntity/Request'
require_relative '../../Factories/User'
require_relative '../../Factories/Profile'
require_relative '../../Factories/Entity'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe 'request model for FollowUserInProfile' do
  it 'prepares data objects for the context' do
    entity                      = Factory.entity
    actor, actor_profile        = factory(entity)
    followed, followed_profile  = factory(entity)

    payload = { followed_id: followed.id }
    payload = JSON.parse(payload.to_json)
    data    = FollowUserInEntity::Request
              .new(payload, actor, actor_profile, entity).prepare
    
    data.fetch(:enforcer)             .must_be_instance_of Follower::Enforcer
    data.fetch(:actor)                .must_equal actor
    data.fetch(:actor_profile)        .must_equal actor_profile
    data.fetch(:followed).id          .must_equal followed.id
    data.fetch(:followed_profile).id  .must_equal followed_profile.id
    data.fetch(:followers).user_id    .must_equal followed.id
    data.fetch(:following).user_id    .must_equal actor.id
    data.fetch(:entity)               .must_equal entity
    data.fetch(:actor_timeline)       .must_be_instance_of Status::Collection
    data.fetch(:latest_statuses)      .must_be_instance_of Status::Collection
  end

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
end # request model for FollowUserInProfile

