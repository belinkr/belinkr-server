#encoding: utf-8
require 'virtus'
require 'aequitas'
require 'forwardable'
require 'statemachine'
require 'Tinto/Member'

module Belinkr
  module Workspace
    module Autoinvitation
      class Member
        extend Forwardable
        include Virtus
        include Aequitas

        MODEL_NAME  = 'autoinvitation'

        attribute :id,              String
        attribute :workspace_id,    String
        attribute :entity_id,       String
        attribute :autoinvited_id,  String
        attribute :state,           String
        attribute :created_at,      Time
        attribute :updated_at,      Time
        attribute :deleted_at,      Time
        attribute :rejected_at,     Time

        validates_presence_of       :entity_id, :workspace_id, :autoinvited_id,
                                    :state
        
        def_delegators  :@state_machine, :accept, :reject
        def_delegators  :@member,   *Tinto::Member::INTERFACE

        def initialize(attributes={})
          super attributes
          @member = Tinto::Member.new self

          @state_machine = Statemachine.build do
            state :pending
            state :accepted
            state(:rejected) { on_entry :set_rejected_at }

            trans :pending, :accept, :accepted
            trans :pending, :reject, :rejected
          end

          @state_machine.context = self
          @state_machine.state = @state if @state
        end

        def state
          sync_state
          super
        end

        def state=(state)
          @state_machine.state = state if @state_machine
          super(state)
        end

        def pending?
          state == 'pending'
        end

        def accepted?
          state == 'accepted'
        end

        def rejected?
          state == 'rejected'
        end

        def storage_key
          "entities:#{entity_id}:workspaces:#{workspace_id}:autoinvitations"
        end

        def link_to(arguments)
          autoinvited         = arguments.fetch(:autoinvited)
          workspace           = arguments.fetch(:workspace)

          self.autoinvited_id = autoinvited.id
          self.workspace_id   = workspace.id
          self.entity_id      = workspace.entity_id
          self
        end #link_to

        private

        def sync_state
          self.state = @state_machine.state.to_s
        end #sync_state

        def set_rejected_at
          self.rejected_at = Time.now
        end #set_rejected_at
      end # Member
    end # Autoinvitation
  end # Workspace
end # Belinkr

