# encoding: utf-8
require 'virtus'
require 'aequitas'
require 'forwardable'
require 'statemachine'
require_relative '../../../Tinto/Member'

module Belinkr
  module Workspace
    module Invitation
      class Member
        extend Forwardable
        include Virtus
        include Aequitas

        MODEL_NAME  = 'invitation'

        attribute :id,              String
        attribute :workspace_id,    String
        attribute :entity_id,       String
        attribute :inviter_id,      String
        attribute :invited_id,      String
        attribute :state,           String
        attribute :created_at,      Time
        attribute :updated_at,      Time
        attribute :deleted_at,      Time
        attribute :rejected_at,     Time

        validates_presence_of       :workspace_id, :entity_id,
                                    :inviter_id, :invited_id, :state

        def_delegators  :@state_machine, :accept, :reject
        def_delegators  :@member, *Tinto::Member::INTERFACE

        def initialize(attributes={})
          super attributes
          @member = Tinto::Member.new self
          
          @state_machine = Statemachine.build do
            state :pending
            state :accepted
            state(:rejected) { on_entry :rejected_at= }

            trans :pending, :accept, :accepted
            trans :pending, :reject, :rejected
            context self
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
          "entities:#{entity_id}:workspaces:invitations"
        end

        def link_to(arguments)
          inviter           = arguments.fetch(:inviter)
          invited           = arguments.fetch(:invited)
          workspace         = arguments.fetch(:workspace)

          self.inviter_id   = inviter.id
          self.invited_id   = invited.id
          self.workspace_id = workspace.id
          self.entity_id    = workspace.entity_id
          self
        end #link_to

        private 

        def sync_state
          self.state = @state_machine.state.to_s 
        end
      end # Member
    end # Invitation
  end # Workspace
end # Belinkr
