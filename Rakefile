require_relative 'config/config_elasticsearch'
task :default => [:reset_elasticsearch]

desc "reset all elasticsearch index"
task :reset_elasticsearch do
  ESConfig::Index.delete_index_list
  ESConfig::Index.put_settings
  ESConfig::Index.get_settings

end
desc "config elasticsearch index"
task :config_es_index_map, [:index] do |t, args|
  ESConfig::Index.put_mappings(args.index)
  ESConfig::Index.get_mappings(args.index)
end


