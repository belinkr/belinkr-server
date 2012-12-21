require_relative 'config/config_elasticsearch'
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


