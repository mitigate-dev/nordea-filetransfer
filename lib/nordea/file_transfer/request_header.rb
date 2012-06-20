module Nordea
  module FileTransfer
    # https://filetransfer.nordea.com/services/CorporateFileService.xsd1.xsd
    class RequestHeader
      include Virtus

      attribute :sender_id, String, :required => true
      attribute :request_id, String, :required => true
      attribute :timestamp, DateTime, :required => true
      attribute :language, String
      attribute :user_agent, String
      attribute :receiver_id, String, :required => true

      def to_hash
        hash = { "RequestHeader" => { } }
        attributes.each do |key, value|
          hash["RequestHeader"][key.to_s.camelcase] = value if value
        end
        hash
      end

      def to_xml
        Gyoku.xml(to_hash)
      end
    end
  end
end
