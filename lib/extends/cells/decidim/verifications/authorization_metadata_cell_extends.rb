# frozen_string_literal: true

module AuthorizationMetadataCellExtends
  private

  def metadata_value(data)
    if data.second.is_a?(FalseClass) || data.second.is_a?(TrueClass)
      t("decidim.verifications.authorizations.renew.#{data.second}")
    else
      data.second
    end
  end
end

Decidim::Verifications::AuthorizationMetadataCell.class_eval do
  prepend AuthorizationMetadataCellExtends
end
