require 'tire'
module Belinkr
  module TireWrapper
    Tire.configure {wrapper Hash}
    def index_store(name, hash)
      Tire.index name do
        store hash
        refresh
      end
    end
    def index_create(name)
      Tire::Index.new(name).create
    end

    def index_delete(name)
      Tire::Index.new(name).delete
    end

    #search returns a hash: {"_index"=>"users", "_type"=>"document", "_id"=>"1",
    #"_score"=>1.0, "_source"=>{"id"=>1, "name"=>"User 1"}}
    def index_search(name, query_string, filter_terms_hash=nil)
      s = Tire.search name do
        query do
          string  "name:*#{query_string}*"

          if filter_terms_hash
            filter_terms_hash.each do |key, value|
              match key, value
            end
          end
        end
        # but seems can't use terms for id when it is too long or contain '-'
        #filter(:terms, filter_terms_hash) if filter_terms_hash
        #filter :terms, :tags => ['ruby']
      end
      s.results
    end

    def index_refresh(name)
      Tire.index name do
        refresh
      end
    end

  end
end
