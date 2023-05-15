# frozen_string_literal: true

# inspired from https://www.stefanwienert.de/blog/2018/11/05/active-storage-migrate-between-providers-from-local-to-amazon/

module AsDownloadPatch
  def open(tempdir: nil, &block)
    ActiveStorage::Downloader.new(self, tempdir: tempdir).download_blob_to_tempfile(&block)
  end
end

Rails.application.config.to_prepare do
  ActiveStorage::Blob.include AsDownloadPatch
end

def migrate(from, to)
  configs = Rails.configuration.active_storage.service_configurations
  from_service = ActiveStorage::Service.configure from, configs
  to_service = ActiveStorage::Service.configure to, configs

  ActiveStorage::Blob.service = from_service

  puts "#{ActiveStorage::Blob.count} Blobs to go..."
  ActiveStorage::Blob.find_each do |blob|
    print "."
    blob.open do |tf|
      checksum = blob.checksum
      to_service.upload(blob.key, tf, checksum: checksum)
    end
  rescue ActiveStorage::FileNotFoundError
    next
  end
end

migrate(:local, :scaleway)
