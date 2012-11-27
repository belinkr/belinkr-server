# encoding: utf-8
require 'minitest/autorun'
require_relative '../../../Locales/Loader'
require_relative '../../../Resources/Activity/Member'
require_relative '../../../Resources/User/Member'
require_relative '../../Factories/User'
require_relative '../../Factories/Activity'

include Belinkr

describe Activity::Member do
  describe 'validations' do
    describe 'entity_id' do
      it "must be present" do
        activity = Activity::Member.new
        activity.valid?.must_equal false
        activity.errors[:entity_id].must_include "entity must not be blank"
      end
    end #entity_id

    describe 'actor' do
      it 'must be present' do
        activity = Activity::Member.new
        activity.valid?.must_equal false
        activity.errors[:actor].must_include 'actor must not be blank'
      end
    end #actor

    describe 'action' do
      it 'must be present' do
        activity = Activity::Member.new
        activity.valid?.must_equal false
        activity.errors[:action].must_include 'action must not be blank'
      end

      it 'must be a valid action' do
        actions = Activity::Member::ACTIONS.join(', ')
        activity = Activity::Member.new(action: 'invalid')
        activity.valid?.must_equal false
        activity.errors[:action]
          .must_include "action must be one of #{actions}"
      end
    end

    describe 'object' do
      it 'must be present' do
        activity = Activity::Member.new
        activity.valid?.must_equal false
        activity.errors[:object].must_include 'object must not be blank'
      end
    end #object

    describe 'description' do
      it 'is optional' do
        activity = Activity::Member.new
        activity.valid?.must_equal false
        activity.errors[:description].must_be_empty
      end

      it 'must not exceed 500 characters' do
        activity = Activity::Member.new(description: 'a' * 251)
        activity.valid?.must_equal false
        activity.errors[:description]
          .must_include 'description must be at most 250 characters long'
      end
    end
  end # validations

  describe 'activity resource integration' do
    it 'accepts any kind of resource for Polymorphic fields' do
      user      = Factory.user
      activity  = Factory.activity(actor: user, action: 'invite', object: user)

      activity.actor.kind           .must_equal 'user'
      activity.actor.resource.first .must_equal user.first

      activity.validate!
      serialized  = activity.to_json
      activity    = Activity::Member.new(JSON.parse(serialized))

      activity.actor.kind           .must_equal 'user'
      activity.actor.resource       .must_be_instance_of User::Member
      activity.object.resource      .must_be_instance_of User::Member
    end
  end # activity resource integration
end # Activity::Member
