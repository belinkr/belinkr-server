# encoding: utf-8
require_relative "Exceptions"
require_relative "Presenter"

module Tinto
  class Dispatcher
    def initialize(current_user, resource=nil, &block)
      @current_user = current_user
      @resource     = resource 
      @operation    = block
    end

    def collection
      [200, response_body]
    rescue => exception
      handle exception
    end

    def create
      [201, response_body]
    rescue => exception
      handle exception
    end

    def read
      [200, response_body]
    rescue => exception
      handle exception
    end

    def update
      [200, response_body]
    rescue => exception
      handle exception
    end

    def delete
      @operation.call
      [204]
    rescue => exception
      handle exception
    end

    def handle(exception)
      case exception
      when Exceptions::InvalidResource    then [400, present]
      when Exceptions::InvalidMember      then [400, present]
      when Exceptions::InvalidCollection  then [400, present]
      when Exceptions::NotAllowed         then [403]
      when Exceptions::NotFound           then [404]
      else raise exception
      end
    end

    private

    def response_body
      @resource = @operation.call
      present
    end

    def present
      Tinto::Presenter.determine_for(@resource)
        .new(@resource, @current_user).as_json
    end
  end # Dispatcher
end # Tinto

