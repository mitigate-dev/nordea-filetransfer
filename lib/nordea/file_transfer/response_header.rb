module Nordea
  module FileTransfer
    # https://filetransfer.nordea.com/services/CorporateFileService.xsd1.xsd
    class ResponseHeader
      include Virtus

      attribute :sender_id, String
      attribute :request_id, String
      attribute :timestamp, DateTime
      attribute :response_code, String
      attribute :response_text, String
      attribute :receiver_id, String
    end
  end
end
