# encoding: utf-8
module Belinkr
  class Factory
    def self.random_number
      rand(999)
    end

    def self.random_string
      (0...8).map { 65.+(rand(25)).chr }.join
    end
  end # Factory
end # Belinkr
