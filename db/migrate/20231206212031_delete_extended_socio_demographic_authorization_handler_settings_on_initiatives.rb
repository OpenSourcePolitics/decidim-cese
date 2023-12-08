# frozen_string_literal: true

class DeleteExtendedSocioDemographicAuthorizationHandlerSettingsOnInitiatives < ActiveRecord::Migration[6.1]
  def change
    Decidim::InitiativesType.where(document_number_authorization_handler: "extended_socio_demographic_authorization_handler").each do |initiatives_type|
      initiatives_type.update!(document_number_authorization_handler: nil)
    end

    Decidim::ResourcePermission.all.each do |resource_permission|
      next if resource_permission.permissions.blank?

      if resource_permission.resource.blank?
        resource_permission.delete
        next
      end

      resource_permission.permissions.each do |action, authorization|
        if authorization.has_key?("authorization_handlers") && authorization["authorization_handlers"].has_key?("extended_socio_demographic_authorization_handler")
          resource_permission.permissions.delete(action)
        end
      end

      resource_permission.save! if resource_permission.changed?
    end
  end
end
