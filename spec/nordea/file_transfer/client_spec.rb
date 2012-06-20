require "spec_helper"

describe Nordea::FileTransfer::Client do
  use_vcr_cassette

  it "should send a request and return response" do
    cert_file = File.expand_path('../../../certs/WSNDEA1234.pem', __FILE__)

    client = Nordea::FileTransfer::Client.new(
      :cert_file => cert_file,
      :private_key_file => cert_file
    )

    response = client.request(:get_user_info) do |r|
      r.request_header.attributes = {
        :sender_id   => 11111111,
        :request_id  => 1232,
        :timestamp   => Time.now,
        :language    => "EN",
        :user_agent  => "Ruby",
        :receiver_id => 123456789
      }
      r.application_request.attributes = {
        :customer_id      => 162355330,
        :command          => "GetUserInfo",
        :timestamp        => Time.now,
        :environment      => "PRODUCTION",
        :execution_serial => "001",
        :software_id      => "Ruby"
      }
    end

    ap response
  end
end