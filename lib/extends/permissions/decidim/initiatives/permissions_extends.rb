# frozen_string_literal: true

module PermissionsExtends
  def permissions
    # Delegate the admin permission checks to the admin permissions class
    return Decidim::Initiatives::Admin::Permissions.new(user, permission_action, context).permissions if permission_action.scope == :admin
    return permission_action if permission_action.scope != :public

    # Non-logged users permissions
    list_public_initiatives?
    read_public_initiative?
    search_initiative_types_and_scopes?
    request_membership?

    return permission_action unless user

    print_public_initiative?
    create_initiative?
    edit_public_initiative?
    update_public_initiative?

    vote_initiative?
    sign_initiative?
    unvote_initiative?

    initiative_attachment?

    initiative_committee_action?
    send_to_technical_validation?

    permission_action
  end

  private

  def print_public_initiative?
    return unless permission_action.subject == :initiative &&
                  permission_action.action == :print

    return allow! if initiative.published? && user == initiative.author

    disallow!
  end
end

Decidim::Initiatives::Permissions.class_eval do
  prepend PermissionsExtends
end
