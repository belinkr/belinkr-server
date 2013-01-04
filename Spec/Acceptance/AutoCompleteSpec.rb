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

MiniTest::Documenter.configure do |configuration|                               
  configuration.decide_docs_dir(__FILE__)                                       
end                                                                             
def app                                                                         
  API.new                                                                       
end                                                                        
                  
request 'GET /autocomplete/users' do
  include Spec::API::Helpers
  before do
    @tire_obj = Object.new.extend TireWrapper
    @tire_obj.index_delete 'users'
  end
                                                                               
  required_parameters(                                                          
         param1: 'description',                                                 
         param2: 'description'                                                  
  )                                                                                                                                                                                                                 
                                                                                
  outcome "Get User List Match query" do                                                    
    user, profile, entity = create_user_and_profile
    query = user.first[0..1]
    @tire_obj.index_store_with_type 'users', user.attributes
    
    uri = URI.escape "/autocomplete/users?q=#{query}"
 
    #get '/autocomplete/users?q=*'                                                                
    get uri, {}, session_for(profile)
  end                                                                           
end 
