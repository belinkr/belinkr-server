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
