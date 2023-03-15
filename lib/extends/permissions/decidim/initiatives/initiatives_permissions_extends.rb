# frozen_string_literal: true

module InitiativesPermissionsExtends
  private

  def creation_enabled?
    Decidim::Initiatives.creation_enabled && (
      Decidim::Initiatives.do_not_require_authorization ||
        Decidim::Initiatives::UserAuthorizations.for(user).any? ||
        Decidim::UserGroups::ManageableUserGroups.for(user).verified.any?) &&
      authorized?(:create, permissions_holder: initiative_type)
  end
end

Decidim::Initiatives::Permissions.class_eval do
  prepend(InitiativesPermissionsExtends)
end
