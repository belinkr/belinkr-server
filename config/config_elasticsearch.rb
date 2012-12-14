# encoding: utf-8
require 'rest-client'
require 'yaml'
require 'json'
ES_HOST = 'http://localhost:9200'
ES = YAML.load File.open('config/elastic_search.yaml')
INDEX_LIST = ES.fetch("index_mapping").keys

module ESConfig
  class Index
    class << self
      def get_settings
        INDEX_LIST.each do |index|
          url = [ES_HOST, index, '_settings?pretty'].join '/'
          puts response = RestClient.get(url)
        end
      end

      def put_settings
        INDEX_LIST.each do |index|
          url = ES_HOST + '/' + index + '/'
          response = RestClient
            .put(url,ES.fetch('default_index_setting').to_json)
        end
      end

      def delete_index_list
        INDEX_LIST.each do |index|
          url = ES_HOST + '/' + index + '/'
          begin
            response = RestClient.delete url
          rescue RestClient::ResourceNotFound
          end
        end
      end
      def put_mappings(index)
        types = ES.fetch('index_mapping').fetch(index).fetch('mappings').keys
        types.each do |type|
          url = [ES_HOST, index, type, '/_mapping'].join '/'
          response = RestClient
            .put(url,ES.fetch('index_mapping')
            .fetch(index).fetch('mappings').to_json)
        end
      end

      def get_mappings(index)
        types = ES.fetch('index_mapping').fetch(index).fetch('mappings').keys
        types.each do |type|
          url = [ES_HOST, index, type, '/_mapping'].join '/'
          response = RestClient.get(url)
          puts response
        end
      end

    end
  end
end


