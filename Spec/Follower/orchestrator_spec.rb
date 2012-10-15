# encoding: utf-8
require 'minitest/autorun'
require_relative '../../app/follower/orchestrator'
require_relative '../../app/status/orchestrator'
require_relative '../../app/status/enforcer'
require_relative '../../app/status/timeliner'
require_relative '../../app/activity/collection'
require_relative '../factories/user'
require_relative '../factories/status'

$redis = Redis.new
$redis.select 8
include Belinkr

describe Follower::Orchestrator do
  before { $redis.flushdb }

  describe '#create' do
    it 'persists a new follow' do
      follower, followed = create_follower_followed_and_follow
      followers_for(followed).must_include follower
    end

    it 'adds the latest tweets from the followed user
    to the general timeline of the follower' do
      follower, followed  = Factory.user.save, Factory.user.save

      5.times { |i| 
        Status::Orchestrator
          .new(followed, Status::Enforcer, Status::Timeliner, :general)
          .create(Factory.status) 
      }

      Follower::Orchestrator.new(follower).create(followed)

      Status::Collection.new(
        user_id: follower.id, entity_id: follower.entity_id, kind: 'general'
      ).size.must_equal 5

    end

    it 'registers an activity' do
      follower, followed = create_follower_followed_and_follow

      activity = Activity::Collection.new(entity_id: follower.entity_id)
                  .all.to_a.first

      activity.actor.resource.id  .must_equal follower.id
      activity.action             .must_equal 'follow'
      activity.object.resource.id .must_equal followed.id
    end

    it 'adds the follower to the followers collection of the followed' do
      follower, followed = create_follower_followed_and_follow

      Follower::Orchestrator.new(follower).create(followed)
      followers_for(followed).must_include follower
    end

    it 'adds the followed to the following collection of the follower' do
      follower, followed = create_follower_followed_and_follow

      Follower::Orchestrator.new(follower).create(followed)
      following_for(follower).must_include followed
    end
  end #create

  describe '#delete' do
    it 'returns the followed' do
      follower, followed = create_follower_followed_and_follow
      Follower::Orchestrator.new(follower).delete(followed).id
        .must_equal followed.id
    end

    it 'removes the follower from the followers collection of the followed' do
      follower, followed = create_follower_followed_and_follow

      Follower::Orchestrator.new(follower).delete(followed)
      followers_for(followed).wont_include follower
    end

    it 'removes the followed from the following collection of the follower' do
      follower, followed = create_follower_followed_and_follow

      Follower::Orchestrator.new(follower).delete(followed)
      following_for(follower).wont_include followed
    end
  end #delete

  def create_follower_followed_and_follow
    follower, followed  = Factory.user.save, Factory.user.save
    Follower::Orchestrator.new(follower).create(followed)

    [follower, followed]
  end

  def followers_for(user)
    Follower::Collection.new(user_id: user.id, entity_id: user.entity_id)
  end

  def following_for(user)
    Following::Collection.new(user_id: user.id, entity_id: user.entity_id)
  end
end # Follower::Orchestrator
