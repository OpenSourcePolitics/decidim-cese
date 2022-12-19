# frozen_string_literal: true

module CreateInitiativeExtends
  extend ActiveSupport::Concern

  included do
    # Creates the initiative and all default components
    def create_initiative
      initiative = build_initiative
      return initiative unless initiative.valid?

      initiative.transaction do
        initiative.save!
        @attached_to = initiative
        create_attachments if process_attachments?

        create_comment_permission_for(initiative) if create_comment_permission?
        create_components_for(initiative)
        send_notification(initiative)
        add_author_as_follower(initiative)
        add_author_as_committee_member(initiative)
      end

      initiative
    end

    def create_comment_permission?
      comments_authorization_handler
    end

    def create_comment_permission_for(initiative)
      form = Decidim::Admin::PermissionsForm.from_params(ah_comment_hash)
                                            .with_context(current_organization: initiative.organization)

      Decidim::Admin::UpdateResourcePermissions.call(form, initiative)
    end

    def ah_comment_hash
      { "component_permissions" => { "permissions" => { "comment" => { "authorization_handlers" => [comments_authorization_handler] } } } }
    end

    private

    def comments_authorization_handler
      @comments_authorization_handler ||= Rails.application.secrets.dig(:decidim, :initiatives, :permissions, :comments, :authorization_handler)
    end
  end
end

Decidim::Initiatives::CreateInitiative.class_eval do
  include(CreateInitiativeExtends)
end
