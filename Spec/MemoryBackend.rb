# encoding: utf-8
require 'set'

module Belinkr
  module Workspace
    class Tracker
      class MemoryBackend
        @workspaces = {}
        @users      = {}

      end # MemoryBackend
    end # Tracker
  end # Workspace
end # Belinkr
