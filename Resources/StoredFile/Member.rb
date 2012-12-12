# encoding: utf-8
require 'forwardable'
require 'virtus'
require 'aequitas'
require 'Tinto/Member'
require_relative './Uploader'

module Belinkr
  module StoredFile
    class Member
      extend Forwardable
      include Virtus
      include Aequitas
 
      MODEL_NAME = "file"

      attribute :id,                String
      attribute :mime_type,         String
      attribute :original_filename, String
      attribute :created_at,        Time
      attribute :updated_at,        Time
      attribute :deleted_at,        Time

      validates_presence_of         :mime_type, :original_filename

      def_delegators :@member,      *Tinto::Member::INTERFACE

      def initialize(attributes={}, descriptor=nil, uploader=nil)
        self.attributes = attributes
        @descriptor     = descriptor
        @uploader       = uploader || Uploader.new(self)
        @member         = Tinto::Member.new self #, !@descriptor
      end

      def sync
        uploader.store! @descriptor
        @member.sync
      end

      def delete
        uploader.retrieve_from_store!(id)
        uploader.remove!
        @member.delete
      end

      def path(version=nil)
        uploader.retrieve_from_store!(id)
        url_for(version)
      end

      def url_for(version=nil)
        return uploader.url unless version
        uploader.send(version.to_sym).url
      end

      def storage_key
        'files'
      end #storage_key

      def image?  
        mime_type =~ /image/
      end #image?

      private

      attr_reader :uploader
    end # Member 
  end # StoredFile
end # Belinkr

