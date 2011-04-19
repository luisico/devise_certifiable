module Devise
  module Models
    module Certifiable
      extend ActiveSupport::Concern

      included do
        belongs_to :certified_by, :polymorphic => true
        before_create :generate_certification_token, :if => :certification_required?
        after_create :request_certification, :if => :certification_required?
        alias_method_chain :send_confirmation_instructions, :certification
      end
      
      def certify!(certification_authority)
        unless_certified do
          unless certification_authority.blank?
            self.certification_token = nil
            self.certified_at = Time.now
            self.certified_by = certification_authority
            save(:validate => false)
            send_confirmation_instructions if confirmation_required?
          else
            self.errors.add(:certified_by, :certification_authority_missing)
            false
          end
        end
      end

      def certified?
        !!certified_at
      end

      # Deliver certification request to certification authority
      def request_certification
        generate_certification_token! if self.certification_token.nil?
        ::Devise.mailer.certification_request(self).deliver
      end
      
      def active_for_authentication?
        super && certified?
      end
      
      def inactive_message
        !certified? ? :uncertified : super
      end
      protected
      
      def certification_required?
        !certified?
      end

      def send_confirmation_instructions_with_certification
        send_confirmation_instructions_without_certification if certified?
      end
      
      def unless_certified
        unless certified?
          yield
        else
          self.errors.add(:email, :already_certified)
          false
        end
      end

      # Generate certification token
      def generate_certification_token
        self.certification_token = self.class.certification_token
        self.certified_at = nil
        self.certified_by = nil
      end

      def generate_certification_token!
        generate_certification_token && save(:validate => false)
      end

      module ClassMethods
        # Generate token
        def certification_token
          generate_token(:certification_token)
        end

        def certify_by_token(certification_token, certification_authority)
          certifiable = find_resource_by_token(certification_token)
          certifiable.certify!(certification_authority) if certifiable.persisted?
          certifiable
        end

        def find_resource_by_token(certification_token)
          certifiable = find_or_initialize_with_error_by(:certification_token, certification_token)
        end

      end
    end
  end
end
