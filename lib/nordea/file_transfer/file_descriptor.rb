module Nordea
  module FileTransfer
    class FileDescriptor
      include Virtus

      attribute :file_reference, String
      attribute :target_id, String
      attribute :service_id, String
      attribute :file_type, String
      attribute :file_timestamp, DateTime
      attribute :status, String
    end
  end
end
