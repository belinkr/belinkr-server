# encoding: utf-8
require 'redis'
require_relative '../../App/Entity/Member'
require_relative '../../App/User/Member'
require_relative '../../App/Profile/Member'
require_relative '../../App/Contexts/CreateEntity'
require_relative '../../App/Contexts/CreateProfileInEntity'

$redis = Redis.new
$redis.flushdb

include Belinkr

@entity = Entity::Member.new(name: 'belinkr labs')

CreateEntity.new(@entity).call

@user   = User::Member.new(
  first:    'Lorenzo',
  last:     'Planas',
  email:    'lp@belinkr.com',
  password: 'changeme'
)
@profile = Profile::Member.new

CreateProfileInEntity.new(@user, @profile, @entity).call

p @profile.inspect
