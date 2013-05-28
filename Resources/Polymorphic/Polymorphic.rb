# encoding: utf-8
require 'virtus'
require 'aequitas'
require_relative '../../Config'

module Belinkr
  class Polymorphic < Virtus::Attribute::Object

    primitive ::Object

    def coerce(value=nil)
      Member.new(value)
    end

    class Member
      include Virtus::ValueObject
      include Aequitas

      MODEL_NAME          = 'polymorphic'
      MAP                 = Belinkr::Config::RESOURCE_MAP
      PREVIEWABLE_FIELDS  = %w{ id name kind resource avatar user_id workspace_id scrapbook_id }

      attribute :kind,        String
      attribute :resource,    Hash
      validates_presence_of   :kind, :resource
      validates_within        :kind, set: MAP.keys

      alias_method :to_hash, :attributes
      alias_method :to_clean_hash, :to_hash

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

      def attributes
        { kind: @kind,
          resource: resource.attributes.select {|k| previewable?(k)} }
      end

      def to_json(*args)
        {
          kind:     @kind,
          resource: json_for(@resource)
        }.to_json(*args)
      end

      def method_missing(method, *args)
        resource.send method, *args if resource.respond_to? method
      end

      def respond_to?(method, include_private=false)
        resource.respond_to?(method, include_private) ||
          super(method, include_private)
      end

      private

      def json_for(resource)
        return resource.select { |k, v| previewable?(k) } if resource.respond_to? :keys
        return resource.attributes.select { |k, v| previewable?(k) } if resource.respond_to? :attributes
        return resource.marshal_dump.select { |k, v| previewable?(k) } if resource.class == OpenStruct
        return resource #unless resource.respond_to? :keys
      end

      def previewable?(key)
        PREVIEWABLE_FIELDS.include?(key.to_s) || key.match(/.*_id$/)
      end

      def hydrate
        return @resource unless @resource.is_a?(Hash)
        klass = klass_for(MAP.fetch(self.kind))
        klass.new(@resource)
      end

      def kind_for(resource)
        MAP.invert.fetch(resource.class.to_s)
      end

      def klass_for(klass_name)
        klass = Object
        klass_name.split('::').each { |part| klass = klass.const_get(part) }
        klass
      end
    end # Member
  end # Polymorphic
end # Belinkr

