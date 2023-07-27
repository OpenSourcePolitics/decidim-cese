# frozen_string_literal: true

module Decidim
  class DuplicatesMetadata
    attr_reader :authorizations

    AUTHORIZATION_NAMES = %w(extended_socio_demographic_authorization_handler).freeze

    def initialize(names = nil)
      @authorizations = Decidim::Authorization.where(name: names.presence || AUTHORIZATION_NAMES)
    end

    def perform
      return if @authorizations.blank?

      update_authorized_users
    end

    def update_authorized_users
      @authorizations.each do |auth|
        next if auth.user.blank? || !auth.user.respond_to?(:extended_data)
        next if auth.user.extended_data.include?(auth.name)

        Rails.logger.debug { "[DuplicatesMetadata] - Updating metadata for user (ID/#{auth.user.id})" }
        auth.user.update!(
          extended_data: auth.user.extended_data.merge(auth.name => auth.metadata)
        )
      end
    end
  end
end
