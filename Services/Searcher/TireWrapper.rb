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
    def index_search(name, term)
      s = Tire.search name do
        query do
          string  "name:*#{term}*"
        end
      end
      s.results
    end
  end
end
