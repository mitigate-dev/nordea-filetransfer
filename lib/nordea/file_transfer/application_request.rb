module Nordea
  module FileTransfer
    # http://www.nordea.fi/sitemod/upload/root/fi_org/liite/ApplicationRequest.xsd
    class ApplicationRequest
      include Virtus

      attribute :customer_id, String, :required => true
      attribute :command, String
      attribute :timestamp, DateTime, :required => true
      attribute :start_date, Date
      attribute :end_date, Date
      attribute :status, String, :length => 1..10 # (NEW|DOWNLOADED|ALL)
      attribute :service_id, String
      attribute :environment, String, :required => true # (PRODUCTION|TEST)
      attribute :file_references, Array[String]
      attribute :user_filename, String
      attribute :target_id, String
      attribute :execution_serial, String
      attribute :encryption, Boolean
      attribute :encryption_method, String
      attribute :compression, Boolean
      attribute :compression_method, String
      attribute :amount_total, BigDecimal
      attribute :transaction_count, Integer
      attribute :software_id, String
      attribute :customer_extension, String
      attribute :file_type, String, :length => 1..40
      attribute :content, String # Base64

      def to_hash
        hash = {
          "ApplicationRequest" => { },
          :attributes! => {
            "ApplicationRequest" => { "xmlns" => "http://bxd.fi/xmldata/" }
          }
        }
        attributes.each do |key, value|
          next unless value
          if value.is_a?(Array) && value.size > 0
            hash["ApplicationRequest"][key.to_s.camelcase] = value.map do |v|
              { "FileReference" => v }
            end
          else
            hash["ApplicationRequest"][key.to_s.camelcase] = value
          end
        end
        hash
      end

      def to_xml
        Gyoku.xml(to_hash)
      end

      def to_signed_xml(options)
        signer = Signer.new(to_xml)
        signer.cert = options[:cert]
        signer.private_key = options[:private_key]
        signer.security_node = signer.document.root
        signer.digest!(signer.document, :id => "")
        signer.sign!(:issuer_serial => true)
        signer.canonicalize
      end

      def to_signed_and_encoded_xml(options)
        Base64.encode64(to_signed_xml(options)).gsub("\n", "")
      end
    end
  end
end
