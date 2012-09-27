module Nordea
  module FileTransfer
    module Config
      @@keys = [
        :cert_file, :private_key_file, :private_key_password,
        :sender_id, :receiver_id, :customer_id, :language, :user_agent, :environment, :software_id
      ]
      attr_accessor(*@@keys)

      def keys
        @@keys
      end

      def configure
        yield self if block_given?
        self
      end

      alias :config :configure
    end
  end
end
