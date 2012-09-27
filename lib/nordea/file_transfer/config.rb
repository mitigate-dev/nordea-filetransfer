module Nordea
  module FileTransfer
    module Config
      attr_accessor :cert_file, :private_key_file, :private_key_password
      attr_accessor :sender_id, :receiver_id, :customer_id, :language, :user_agent, :environment, :software_id

      def configure
        yield self if block_given?
        self
      end

      alias :config :configure
    end
  end
end
