# frozen_string_literal: true

module Decidim
  # This class deals with uploading hero images to ParticipatoryProcesses.
  class OfficialSignatureUploader < RecordImageUploader
    set_variants do
      { default: { resize_to_fit: [200, 200] } }
    end
  end
end
