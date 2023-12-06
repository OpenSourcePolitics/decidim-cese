# frozen_string_literal: true

class MigrateExtendedSocioDemographicAuthorizationHandlerData < ActiveRecord::Migration[6.1]
  def change
    Decidim::Authorization.where(name: "extended_socio_demographic_authorization_handler").each do |authorization|
      next if authorization.user.deleted?

      # We don't migrate the email because we don't want to confirm it if needed
      authorization.user.name = "#{authorization.metadata["first_mane"]} #{authorization.metadata["first_mane"]}"
      authorization.user.extended_data = {
        city: authorization.metadata["city"],
        address: authorization.metadata["address"],
        birth_date: authorization.metadata["birth_date"],
        postal_code: authorization.metadata["postal_code"],
        certification: authorization.metadata["certification"]
      }
      authorization.user.save
      authorization.delete
    end
  end
end
