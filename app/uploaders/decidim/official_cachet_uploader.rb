# frozen_string_literal: true

module Decidim
  # This class deals with uploading hero images to ParticipatoryProcesses.
  class OfficialCachetUploader < RecordImageUploader
    set_variants do
      { default: { resize_to_fit: [250, 250] } }
    end
  end
end
