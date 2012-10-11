# encoding: utf-8
require "virtus"
require "aequitas"
require_relative "../../Config"

module Belinkr
  class Polymorphic < Virtus::Attribute::Object

    primitive ::Object

    def coerce(value=nil)
      Member.new(value)
    end

    class Member
      include Virtus::ValueObject
      include Aequitas

      MODEL_NAME  = "polymorphic"
      MAP         = Belinkr::Config::RESOURCE_MAP

      attribute :kind,        String
      attribute :resource,    Hash
      validates_presence_of   :kind, :resource
      validates_within        :kind, set: MAP.keys

      alias_method :to_hash, :attributes

      def initialize(resource_or_options={})
        if resource_or_options.is_a? Hash
          super(resource_or_options)
        else
          self.resource = resource_or_options
        end
      end

      def resource
        hydrate if @kind && @resource
      end

      def resource=(resource)
        self.kind = kind_for(resource) if resource && !resource.is_a?(Hash)
        super(resource)
      end

      def to_json(*args)
        attributes.to_json
      end

      private

      def hydrate
        klass = klass_for(MAP.fetch(self.kind)) 
        klass.new(@resource)
      end

      def kind_for(resource)
        MAP.invert.fetch(resource.class.to_s)
      end

      def klass_for(klass_name)
        klass = Object
        klass_name.split("::").each { |part| klass = klass.const_get(part) }
        klass
      end
    end # Member
  end # Polymorphic
end # Belinkr
