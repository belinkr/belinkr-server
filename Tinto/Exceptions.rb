# encoding: utf-8

module Tinto
  module Exceptions 
    class NotAllowed < RuntimeError; end
    class NotFound < RuntimeError; end
    class InvalidResource < RuntimeError; end
    class PersistenceError < RuntimeError; end
  end # Exceptions
end # Tinto

