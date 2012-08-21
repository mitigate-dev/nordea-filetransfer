require "spec_helper"

describe Nordea::FileTransfer::Client do
  subject :client do
    Nordea::FileTransfer::Client.new(
      :cert_file => cert_file,
      :private_key_file => cert_file
    )
  end

  let :cert_file do
    File.expand_path('../../../certs/WSNDEA1234.pem', __FILE__)
  end

  describe "GetUserInfo" do
    it "should send a request and return response" do
      response = VCR.use_cassette('get_user_info') do
        client.request(:get_user_info) do |r|
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
      end

      response.response_header.request_id.should == "1232"
      response.application_response.user_file_types.size.should be > 0
    end
  end

  describe "DownloadFileList" do
    it "should send a request and return response" do
      response = VCR.use_cassette('download_file_list') do
        client.request(:download_file_list) do |r|
          r.request_header.attributes = {
            :sender_id   => 11111111,
            :request_id  => 1233,
            :timestamp   => Time.now,
            :language    => "EN",
            :user_agent  => "Ruby",
            :receiver_id => 123456789
          }
          r.application_request.attributes = {
            :customer_id      => 162355330,
            :command          => "DownloadFileList",
            :timestamp        => Time.now,
            :status           => "ALL",
            :environment      => "PRODUCTION",
            :target_id        => "11111111A1",
            :execution_serial => "001",
            :software_id      => "Ruby",
            :file_type        => "NDCORPAYL"
          }
        end
      end

      response.response_header.request_id.should == "1233"
      response.application_response.file_descriptors.size.should be > 0
    end
  end
end
