# encoding: utf-8
require 'i18n'
require 'forwardable'
require 'virtus'
require 'aequitas'
require 'statemachine'
require_relative '../../Tinto/Member'
require_relative '../../Tinto/Utils'

module Belinkr
  module Invitation
    class Member
      extend Forwardable
      include Virtus
      include Aequitas

      MODEL_NAME        = 'invitation'
      WHITELIST         = %w{ invited_name invited_email locale }

      attribute :id,              String
      attribute :entity_id,       Integer
      attribute :inviter_id,      Integer
      attribute :invited_name,    String
      attribute :invited_email,   String
      attribute :locale,          String, default: 'en'
      attribute :state,           String
      attribute :created_at,      Time
      attribute :updated_at,      Time
      attribute :deleted_at,      Time

      validates_presence_of       :id, :entity_id, :inviter_id,
                                  :invited_name, :invited_email, :locale 
      validates_with_block        :id do Tinto::Utils.is_sha256?(@id) end
      validates_length_of         :invited_name, min: 1, max: 150
      validates_format_of         :invited_email, as: :email_address
      validates_numericalness_of  :entity_id, :inviter_id
      validates_within            :locale, 
                                    set: I18n.available_locales.map(&:to_s)

      def_delegators :@fsm,       :accept
      def_delegators :@member,    :==, :score, :to_json, :read, :save,
                                  :update, :delete, :undelete, :destroy

      alias_method :to_hash, :attributes

      def initialize(attrs={}, retrieve=true)
        super(attrs)
        @member  = Tinto::Member.new self, retrieve
        self.id  ||= Tinto::Utils.generate_token

        @fsm = Statemachine.build do
          state :pending
          state :accepted

          trans :pending, :accept, :accepted
        end

        @fsm.state = @state if @state
      end

      def pending?
        state == 'pending'
      end

      def accepted?
        state == 'accepted'
      end

      def state
        sync_state
        super
      end

      def state=(state)
        @fsm.state = state if @fsm
        super(state)
      end

      def storage_key
        "invitations"
      end

      private

      def sync_state
        self.state = @fsm.state.to_s
      end
    end # Member
  end # Invitation
end # Belinkr
