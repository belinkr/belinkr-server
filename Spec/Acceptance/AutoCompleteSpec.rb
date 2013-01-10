require_relative '../Support/Helpers'
require_relative '../Support/DocHelpers'
require_relative '../../API'
require_relative '../../API/Autocomplete'
require_relative '../../Services/Searcher/TireWrapper'
include Belinkr
$redis ||= Redis.new
$redis.select 8
module Belinkr
  class API
    use PryRescue::Rack
  end
end



describe 'Autocomplete' do
  include Spec::API::Helpers
  def app; API.new; end
  before do
    @tire_obj = Object.new.extend TireWrapper
    @tire_obj.index_delete 'users'
    @tire_obj.index_delete 'workspaces'
    @tire_obj.index_delete 'scrapbooks'
  end

  request 'GET /autocomplete/users' do
    outcome "Get User List Match query" do
      user, profile, entity = create_user_and_profile
      query = user.first[0..1]
      @tire_obj.index_store_with_type 'users', user.attributes

      uri = URI.escape "/autocomplete/users?q=#{query}"
      get uri, {}, session_for(profile)
    end
  end

  request 'GET /autocomplete/workspaces' do
    outcome "GET Workspace List Match query" do
      workspaces_mapping_hash = {
        workspace: {
          properties: {
            entity_id: {
              type: 'string',
              index: 'not_analyzed'
            },
            name: {
              type: 'string'
            }
          }
        }

      }

      @tire_obj.index_create 'workspaces', workspaces_mapping_hash

      @user, @profile, @entity = create_user_and_profile
      @workspace = workspace_by(@profile)
      hash= @workspace.attributes
      [:updated_at, :created_at, :deleted_at].each do |timestamp|
        hash[timestamp] = hash[timestamp].iso8601 if hash[timestamp]
      end

      @tire_obj.index_store_with_type 'workspaces', hash
      query = @workspace.name
      uri = URI.escape "/autocomplete/workspaces?q=#{query}"
      get uri, {}, session_for(@profile)

    end
  end
  request 'GET /autocomplete/scrapbooks' do
    outcome "Get Scrapbook List Match query" do
      scrapbooks_mapping_hash = {
        scrapbook: {
          properties: {
            user_id: {
              type: 'string',
              index: 'not_analyzed'
            },
            name: {
              type: 'string'
            }
          }
        }

      }

      @tire_obj.index_create 'scrapbooks', scrapbooks_mapping_hash

      user, profile, entity = create_user_and_profile
      scrapbook = scrapbook_by(profile)
      scrapbook.sync
      hash = scrapbook.attributes

      [:updated_at, :created_at, :deleted_at].each do |timestamp|
        hash[timestamp] = hash[timestamp].iso8601 if hash[timestamp]
      end
      @tire_obj.index_store_with_type 'scrapbooks', hash
      query = scrapbook.name
      uri = URI.escape "/autocomplete/scrapbooks?q=#{query}"
      # if call fetch in Tinto::Precenter::Collection#as_poro, it would fail
      get uri, {}, session_for(profile)
    end

  end
  def workspace_by(profile)
    name = Factory.random_string
    workspace = Factory.workspace name: name, user_id: profile.user_id, entity_id: profile.entity_id
    #post "/workspaces", { name: name }.to_json, session_for(profile)
    #JSON.parse(last_response.body)
  end

  def scrapbook_by(profile)
    name = Factory.random_string
    scrapbook = Factory.scrapbook name: name, user_id: profile.user_id
    #post "/scrapbooks", { name: name }.to_json, session_for(profile)
    #JSON.parse(last_response.body)
  end

end
