# encoding: utf-8
require 'pry'
require_relative '../Factories/User'
require_relative '../Factories/Profile'
require_relative '../Factories/Entity'
require_relative '../../Resources/Session/Member'
require_relative '../../Resources/Profile/Collection'
require_relative '../../Cases/CreateProfileInEntity/Context'

module Belinkr
  module Spec
    module API
      module Helpers
        def session_for(profile)
          session = Session::Member.new(
            user_id:      profile.user_id, 
            profile_id:   profile.id,
            entity_id:    profile.entity_id 
          ).sync

          { "rack.session" => { auth_token: session.id } }
        end

        def create_user_and_profile(entity=nil)
          user      = Factory.user(profiles: [])
          profile   = Factory.profile
          entity    ||= Factory.entity.sync
          profiles  = Profile::Collection.new(entity_id: entity.id)

          context   = CreateProfileInEntity::Context.new(
                        actor:    user, 
                        profile:  profile, 
                        profiles: profiles, 
                        entity:   entity
                      )
          context.run
          [user, profile, entity]
        end

        def dump
          File.open('error.html','w') { |f| f<< last_response.body }
        end
      end # Helpers
    end # API
  end # Spec
end # Belinkr
