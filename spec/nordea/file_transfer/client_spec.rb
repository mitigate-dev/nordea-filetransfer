require "spec_helper"

describe Nordea::FileTransfer::Client do
  subject :client do
    Nordea::FileTransfer::Client.new(
      :cert_file        => cert_file,
      :private_key_file => cert_file,
      :sender_id        => 11111111,
      :language         => "EN",
      :environment      => "PRODUCTION",
      :user_agent       => "Ruby",
      :software_id      => "Ruby"
    )
  end

  let :cert_file do
    File.expand_path('../../../certs/WSNDEA1234.pem', __FILE__)
  end

  describe "GetUserInfo" do
    it "should send a request and return response" do
      response = VCR.use_cassette('get_user_info') do
        client.request :get_user_info do |header, request|
          header.receiver_id  = 123456789
          request.customer_id = 162355330
        end
      end
      response.application_response.user_file_types.size.should be > 0
    end
  end

  describe "DownloadFileList" do
    it "should send a request and return response" do
      response = VCR.use_cassette('download_file_list') do
        client.request :download_file_list do |header, request|
          header.receiver_id  = 123456789
          request.customer_id = 162355330
          request.status      = "ALL"
          request.target_id   = "11111111A1"
          request.file_type   = "NDCORPAYL"
        end
      end
      response.application_response.file_descriptors.size.should be > 0
    end
  end

  describe "DownloadFile" do
    # http://www.nordea.fi/sitemod/upload/root/fi_org/liite/e/yritys/pdf/kurssi_aineisto.pdf
    it "send a request and return response with exchange rates" do
      response = VCR.use_cassette('download_file') do
        client.request :download_file do |header, request|
          header.receiver_id      = 123456789
          request.customer_id     = 162355330
          request.file_references = ["1320120312210394"]
          request.target_id       = "11111111A1"
          request.software_id     = "Ruby"
          request.file_type       = "VKEUR"
        end
      end
      response.application_response.content.should include("VK01")
    end
  end
end
