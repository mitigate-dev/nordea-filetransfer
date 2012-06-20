module Nordea
  module FileTransfer
    class Request
      attr_accessor :cert, :private_key
      attr_accessor :request_header
      attr_accessor :application_request

      def to_hash
        { "RequestHeader" => request_header.to_hash["RequestHeader"],
          "ApplicationRequest" => application_request.to_signed_and_encoded_xml({
            :cert => cert,
            :private_key => private_key
          })
        }
      end
    end
  end
end
