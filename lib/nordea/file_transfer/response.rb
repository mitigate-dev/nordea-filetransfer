module Nordea
  module FileTransfer
    class Response
      include Virtus

      attribute :response_header, ResponseHeader
      attribute :application_response, ApplicationResponse
      attribute :signature, Hash
    end
  end
end
