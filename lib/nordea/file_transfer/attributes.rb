require "base64"

module Nordea
  module FileTransfer
    module Attributes
      class EncodedBase64String < Virtus::Attribute::Object
        primitive String

        def coerce(value)
          value && Base64.encode64(value)
        end
      end

      class DecodedBase64String < Virtus::Attribute::Object
        primitive String

        def coerce(value)
          value && Base64.decode64(value)
        end
      end
    end
  end
end
