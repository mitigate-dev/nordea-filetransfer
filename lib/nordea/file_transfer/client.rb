module Nordea
  module FileTransfer
    class Client < Savon::Client
      attr_reader :cert_file, :private_key_file

      def initialize(options = {})
        @cert_file = options[:cert_file]
        @private_key_file = options[:private_key_file]

        super do |wsdl, http|
          # Do not fetch wsdl document, use namespace and endpoint instead.
          wsdl.document = "https://filetransfer.nordea.com/services/CorporateFileService?wsdl"
          wsdl.endpoint = "https://filetransfer.nordea.com/services/CorporateFileService"
          certs = Akami::WSSE::Certs.new(:cert_file => @cert_file, :private_key_file => @private_key_file)
          wsse.signature = Akami::WSSE::Signature.new(certs)
          wsse.verify_response = false
        end
      end

      def cert
        OpenSSL::X509::Certificate.new(File.read(cert_file))
      end

      def private_key
        OpenSSL::PKey::RSA.new(File.read(private_key_file))
      end

      # Actions:
      # * :delete_file,
      # * :download_file,
      # * :download_file_list,
      # * :get_user_info,
      # * :upload_file
      def request(action)
        response = super action do
          soap.namespaces["xmlns"]      = "http://model.bxd.fi"
          soap.namespaces["xmlns:xsns"] = "http://bxd.fi/CorporateFileService"

          timestamp = Time.now

          req = Request.new
          req.cert = cert
          req.private_key = private_key
          req.request_header = RequestHeader.new
          req.request_header.timestamp = timestamp
          req.application_request = ApplicationRequest.new
          req.application_request.command = action.to_s.camelcase
          req.application_request.timestamp = timestamp

          yield req

          soap.body = req.to_hash
        end
        Response.new(response.to_hash[:"#{action}out"])
      end
    end
  end
end
