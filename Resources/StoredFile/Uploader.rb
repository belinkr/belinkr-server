# encoding: utf-8
require 'carrierwave'
require 'mini_magick'

module Belinkr
  module StoredFile
    class Uploader < CarrierWave::Uploader::Base
      include CarrierWave::MimeTypes
      include CarrierWave::MiniMagick

      storage :file
      process :set_content_type
      version(:small, if: :image?)  { process resize_to_fit: [200, 200] }
      version(:mini,  if: :image?)  { process resize_to_fit: [80, 80] }

      def image?(new_file)
        #recheck_mime_for(new_file)
        (new_file.content_type || model.mime_type).include?('image') 
      end

      def filename
        model.id
      end

      def store_dir
        "files/#{nested_tree}"
      end

      def cache_dir
        'files/tmp'
      end

      private

      def nested_tree
        filename.chars.to_a.each_slice(4).map { |s| s.join }.join("/")
      end

      #def recheck_mime_for(new_file)
      #  if model.mime_type == 'application/octet-stream'
      #    if RUBY_PLATFORM =~ /java/
      #      parser = Rika::Parser.new(new_file.path)
      #      real_content_type = parser.media_type
      #    else
      #      cmd = "file --mime --br #{new_file.path}"
      #      real_content_type = `#{cmd}`.split(";").first
      #    end
      #    if new_file.respond_to?(:content_type=)
      #      new_file.content_type = real_content_type
      #    else
      #      new_file.instance_variable_set(:@content_type, real_content_type)
      #    end
      #    # update the model mime_type if not 'application/octet-stream'
      #    if new_file.content_type != "application/octet-stream"
      #      model.mime_type = new_file.content_type
      #      model.instance_variable_get(:@member).save
      #    end
      #  end
      #end
    end # Uploader
  end # StoredFile
end # Belinkr

