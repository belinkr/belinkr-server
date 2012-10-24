# encoding: utf-8
require_relative '../Factories/User'
require_relative '../Factories/Profile'
require_relative '../Factories/Entity'
require_relative '../../App/Session/Member'
require_relative '../../App/Contexts/CreateProfileInEntity'

module Belinkr
  module Spec
    module API
      module Helpers
        def session_for(profile)
          return @http_session if @http_session
          session = Session::Member.new(
            user_id:      profile.user_id, 
            profile_id:   profile.id,
            entity_id:    profile.entity_id 
          ).sync

          @http_session = { "rack.session" => { auth_token: session.id } }
        end

        def create_user_and_profile(entity_id=nil)
          user      = Factory.user
          profile   = Factory.profile
          entity    = Factory.entity(id: entity_id)
          profiles  = Profile::Collection.new(entity_id: entity.id)

          context   = CreateProfileInEntity.new(user, profile, profiles, entity)
          context.call
          context.sync
          entity.sync
          profile
        end

        def dump
          File.open('error.html','w') { |f| f<< last_response.body }
        end
      end # Helpers
    end # API
  end # Spec
end # Belinkr
