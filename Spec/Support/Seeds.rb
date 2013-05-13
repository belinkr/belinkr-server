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

@entity = Entity::Member.new(name: ENV['belinkr_init_entity_name'] || 'belinkr labs')
@entities = Entity::Collection.new

CreateEntity::Context.new(entity: @entity, entities: @entities).run

@user   = User::Member.new(
  first:    ENV['belinkr_init_user_first'] || 'Lorenzo',
  last:     ENV['belinkr_init_user_last'] || 'Planas',
  email:    ENV['belinkr_init_user_email'] || 'lp@belinkr.com',
  password: ENV['belinkr_init_user_password'] || 'changeme'
)

@user2   = User::Member.new(
  first:    ENV['belinkr_init_user_first'] || 'LLLLLL',
  last:     ENV['belinkr_init_user_last'] || 'PPPPPPP',
  email:    ENV['belinkr_init_user_email'] || 'lp@lp.com',
  password: ENV['belinkr_init_user_password'] || 'changeme'
)

@profile = Profile::Member.new
@profile2 = Profile::Member.new

@profiles = Profile::Collection.new entity_id: @entity.id

CreateProfileInEntity::Context.new(
  actor: @user,
  profile: @profile,
  profiles: @profiles,
  entity: @entity,
).run

CreateProfileInEntity::Context.new(
  actor: @user2,
  profile: @profile2,
  profiles: @profiles,
  entity: @entity,
).run
p @profile.inspect
p @profile2.inspect
