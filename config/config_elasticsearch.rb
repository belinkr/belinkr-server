# encoding: utf-8
require 'rest-client'
require 'yaml'
require 'json'
ES_HOST = 'http://localhost:9200'
ES = YAML.load File.open('config/elastic_search.yaml')
INDEX_LIST = ES.fetch("index_mapping").keys

module ESConfig
  class Index
      def get_settings
        INDEX_LIST.each do |index|
          url = "#{ES_HOST}/#{index}/_settings?pretty=true"
          puts response = RestClient.get(url)
        end
      end

      def put_settings
        INDEX_LIST.each do |index|
          url = "#{ES_HOST}/#{index}"
          response = RestClient
            .put(url,ES.fetch('default_index_setting').to_json)
        end
      end

      def delete_index_list
        INDEX_LIST.each do |index|
          url = "#{ES_HOST}/#{index}"
          begin
            response = RestClient.delete url
          rescue RestClient::ResourceNotFound
            puts "try to delete nonexist index #{index}"
          end
        end
      end

      def put_mappings(index)
        types = index_types(index)
        types.each do |type, data|
          url = "#{ES_HOST}/#{index}/#{type}/_mapping"
          puts url
          response = RestClient.put(url, {type => data}.to_json)
        end
      end

      def get_mappings(index)
        types = index_types(index).keys
        types.each do |type|
          url = "#{ES_HOST}/#{index}/#{type}/_mapping"
          response = RestClient.get(url)
          puts response
        end
      end

      def index_types(index)
        types = ES.fetch('index_mapping').fetch(index).fetch('mappings')
      end

  end
end


