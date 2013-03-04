require './Config/Elasticsearch'
task :default => [:reset_elasticsearch]

desc "reset all elasticsearch index"
task :reset_elasticsearch do
  esindex = ESConfig::Index.new
  esindex.delete_index_list
  esindex.put_settings
  esindex.get_settings

end

desc "config elasticsearch index"
task :config_es_index_map do 
  unless ENV['INDEX']
    raise "Need to Provide an INDEX: rake config_es_index_map INDEX=workspaces"
  end

  index = ENV['INDEX']
  esindex = ESConfig::Index.new
  esindex.put_mappings(index)
  esindex.get_mappings(index)
end

desc <<-EOL
seeds
set following environment variables first:
belinkr_init_entity_name
belinkr_init_user_first
belinkr_init_user_last
belinkr_init_user_email
belinkr_init_user_password
EOL
task :seeds do
  require './Spec/Support/Seeds' 
end
