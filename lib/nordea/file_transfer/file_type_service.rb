module Nordea
  module FileTransfer
    class FileTypeService
      include Virtus

      attribute :service_id, String
      attribute :service_id_owner_name, String
      attribute :service_id_type, String
      attribute :service_id_text, String
    end
  end
end
