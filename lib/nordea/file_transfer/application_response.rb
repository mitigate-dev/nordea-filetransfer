module Nordea
  module FileTransfer
    # http://www.nordea.fi/sitemod/upload/root/fi_org/liite/ApplicationResponse.xsd
    class ApplicationResponse
      include Virtus

      attribute :customer_id, String
      attribute :timestamp, DateTime
      attribute :response_code, String
      attribute :response_text, String
      attribute :execution_serial, String
      attribute :encrypted, Boolean
      attribute :encryption_method, String
      attribute :compressed, Boolean
      attribute :compression_method, String
      attribute :amount_total, BigDecimal
      attribute :transaction_count, Integer
      attribute :file_descriptors, Array[FileDescriptor], :default => []
      attribute :customer_extension, String
      attribute :file_type, String
      attribute :user_file_types, Array[UserFileType], :default => []

      attribute :content, Attributes::Base64String
      attribute :signature, Hash

      def initialize(attributes = {})
        if attributes.is_a?(String)
          attributes = Nori.parse(Base64.decode64(attributes))[:application_response]
        end
        if attributes[:user_file_types]
          attributes[:user_file_types] = Array.wrap(attributes[:user_file_types][:user_file_type])
        end
        if attributes[:file_descriptors]
          attributes[:file_descriptors] = Array.wrap(attributes[:file_descriptors][:file_descriptor])
        end
        super(attributes)
      end
    end
  end
end
