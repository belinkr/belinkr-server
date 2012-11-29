# encoding: utf-8
require 'redis'
require_relative '../../Resources/Entity/Member'
require_relative '../../Resources/Entity/Collection'
require_relative '../../Resources/User/Member'
require_relative '../../Resources/Profile/Member'
require_relative '../../Resources/Profile/Collection'
require_relative '../../Cases/CreateEntity/Context'
require_relative '../../Cases/CreateProfileInEntity/Context'

$redis = Redis.new
$redis.flushdb

include Belinkr

@entity = Entity::Member.new(name: 'belinkr labs')
@entities = Entity::Collection.new

CreateEntity::Context.new(entity: @entity, entities: @entities).run

@user   = User::Member.new(
  first:    'Lorenzo',
  last:     'Planas',
  email:    'lp@belinkr.com',
  password: 'changeme'
)
@profile = Profile::Member.new
@profiles = Profile::Collection.new entity_id: @entity.id

CreateProfileInEntity::Context.new(
  actor: @user,
  profile: @profile,
  profiles: @profiles,
  entity: @entity,
).run

p @profile.inspect
