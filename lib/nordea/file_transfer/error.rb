module Nordea
  module FileTransfer
    class Error < RuntimeError
      attr_reader :code

      def initialize(code, message)
        @code = code.to_s
        super("#{message} (##{code})")
      end
    end
  end
end
