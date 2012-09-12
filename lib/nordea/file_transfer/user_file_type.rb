module Nordea
  module FileTransfer
    class UserFileType
      include Virtus

      attribute :target_id, String
      attribute :file_type, String
      attribute :file_type_name, String
      attribute :country, String
      attribute :description, String
      attribute :direction, String
      attribute :file_type_services, Array[FileTypeService], :default => []

      def initialize(attributes = {})
        if attributes[:file_type_services]
          attributes[:file_type_services] = Array.wrap(attributes[:file_type_services][:file_type_service])
        end
        super(attributes)
      end
    end
  end
end
