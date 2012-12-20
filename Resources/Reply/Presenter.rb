# encoding: utf-8
require 'json'

module Belinkr
  module Reply
    class Presenter
      def initialize(reply, scope={})
        @reply = reply
      end #initialize

      def as_json(*args)
        as_poro.to_json(*args)
      end #as_json

      def as_poro
        {
          id:             reply.id,
          text:           reply.text,
          files:          reply.files
        }.merge! Tinto::Presenter.timestamps_for(reply)
         .merge! Tinto::Presenter.errors_for(reply)
         .merge! links
      end #as_poro

      private

      def links
        status_path = "/statuses/#{reply.status_id}"
        {
          links: {
            self:    "#{status_path}/replies/#{reply.id}",
            status:  status_path,
            author:  "/users/#{reply.user_id}",
            avatar:  reply.author.avatar
          }
        }
      end #links
    end # Presenter
  end # Status
end # Belinkr

