# frozen_string_literal: true

require "decidim/duplicates_metadata"

namespace :decidim do
  namespace :duplicates do
    desc "Merge all authorization encrypted metadata to decrypted metadata in user extended data"
    task metadata: :environment do
      metadata_duplicator = Decidim::DuplicatesMetadata.new
      puts "[decidim:duplicates:metadata] - Duplicating authorizations metadata..."
      puts "[decidim:duplicates:metadata] - Found #{metadata_duplicator.authorizations.count} authorizations..."
      metadata_duplicator.perform
      puts "[decidim:duplicates:metadata] - Terminated."
    end
  end
end
