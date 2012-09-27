require "spec_helper"

describe Nordea::FileTransfer::Client do
  subject :client do
    Savon.configure do |config|
      config.log = false
    end
    Nordea::FileTransfer::Client.new(
      :cert_file        => cert_file,
      :private_key_file => cert_file,
      :sender_id        => 11111111
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
      response.application_response.user_file_types.each do |user_file_type|
        user_file_type.file_type_services.size.should be > 0
      end
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

    it "should raise error #29 when file references are not present" do
      lambda {
        response = VCR.use_cassette('download_file_error') do
          client.request :download_file do |header, request|
            header.receiver_id      = 123456789
            request.customer_id     = 162355330
            request.target_id       = "11111111A1"
            request.software_id     = "Ruby"
            request.file_type       = "VKEUR"
          end
        end
      }.should raise_error(
        Nordea::FileTransfer::Error,
        "Invalid parameters: At least one FileReference required for downloading (#29)"
      )
    end
  end

  # http://www.nordea.fi/sitemod/upload/root/fi_org/liite/ApplicationRequest_UploadFile.xml
  describe "UploadFile" do
    it "should upload file and return status OK" do
      pending "Couldn't find a good test case"
      response = VCR.use_cassette('upload_file') do
        response = client.request :upload_file do |header, request|
          header.receiver_id      = 11111111
          request.customer_id     = 679155330
          request.target_id       = "11111111A1"
          # request.service_id      = "111111111" #"NDEAFIHHXXX-FI1-EUR-111111111"
          request.file_type       = "CNFTC000S"
          request.user_filename   = "T.TXT"
          request.content         = Base64.decode64("PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4NCjwhLS1TRVBBIENUIGFuZCBvdGhlciBwYXltZW50cyBzYW1wbGUgZmlsZSwgZWRpdGVkIGJ5IE5vcmRlYSBKdWx5IDIwMDkgSksgLS0+DQo8RG9jdW1lbnQgeG1sbnM9InVybjppc286c3RkOmlzbzoyMDAyMjp0ZWNoOnhzZDpwYWluLjAwMS4wMDEuMDIiIHhtbG5zOnhzaT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS9YTUxTY2hlbWEtaW5zdGFuY2UiIHhzaTpzY2hlbWFMb2NhdGlvbj0idXJuOmlzbzpzdGQ6aXNvOjIwMDIyOnRlY2g6eHNkOnBhaW4uMDAxLjAwMS4wMiYjeEQ7JiN4QTtwYWluLjAwMS4wMDEuMDIueHNkIj4NCiAgPHBhaW4uMDAxLjAwMS4wMj4NCiAgICA8R3JwSGRyPg0KICAgICAgPE1zZ0lkPjIwMTAxMDIxLTAwMDAwMDI8L01zZ0lkPg0KICAgICAgPENyZUR0VG0+MjAxMC0wOS0wNlQxMDozMDowMDwvQ3JlRHRUbT4NCiAgICAgIDxCdGNoQm9va2c+dHJ1ZTwvQnRjaEJvb2tnPg0KICAgICAgPE5iT2ZUeHM+MTwvTmJPZlR4cz4NCiAgICAgIDxDdHJsU3VtPjEwMC4wMTwvQ3RybFN1bT4NCiAgICAgIDxHcnBnPk1JWEQ8L0dycGc+DQogICAgICA8SW5pdGdQdHk+DQogICAgICAgIDxObT5Hcm91cCBGaW5hbmNlPC9ObT4NCiAgICAgICAgPFBzdGxBZHI+DQogICAgICAgICAgPEFkckxpbmU+QWxla3NhbnRlcmlua2F0dSAyMzwvQWRyTGluZT4NCiAgICAgICAgICA8QWRyTGluZT5GSS0wMDEwMCBIZWxzaW5raTwvQWRyTGluZT4NCiAgICAgICAgICA8Q3RyeT5GSTwvQ3RyeT4NCiAgICAgICAgPC9Qc3RsQWRyPg0KICAgICAgPC9Jbml0Z1B0eT4NCiAgICA8L0dycEhkcj4NCiAgICA8IS0tDQoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqDQpFbnNpbW3DpGluZW4gUGF5bWVudCBJbmZvcm1hdGlvbiAtZXLDpA0KKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKg0KLS0+DQogICAgPFBtdEluZj4NCiAgICAgIDxQbXRJbmZJZD4yMDEwMTAyMS0xMjM0NTYtMDI8L1BtdEluZklkPg0KICAgICAgPFBtdE10ZD5UUkY8L1BtdE10ZD4NCiAgICAgIDxSZXFkRXhjdG5EdD4yMDEwLTA5LTI0PC9SZXFkRXhjdG5EdD4NCiAgICAgIDxEYnRyPg0KICAgICAgICA8Tm0+T3kgQ29tcGFueSBBYiA8L05tPg0KICAgICAgICA8UHN0bEFkcj4NCiAgICAgICAgICA8QWRyTGluZT5NYW5uZXJoZWltaW50aWUgNjY8L0FkckxpbmU+DQogICAgICAgICAgPEFkckxpbmU+RkktMDAyNjAgSGVsc2lua2k8L0FkckxpbmU+DQogICAgICAgICAgPEN0cnk+Rkk8L0N0cnk+DQogICAgICAgIDwvUHN0bEFkcj4NCiAgICAgICAgPElkPg0KICAgICAgICAgIDxPcmdJZD4NCiAgICAgICAgICAgIDxCa1B0eUlkPjA5ODc2NTQzMjE8L0JrUHR5SWQ+DQogICAgICAgICAgPC9PcmdJZD4NCiAgICAgICAgPC9JZD4NCiAgICAgIDwvRGJ0cj4NCiAgICAgIDxEYnRyQWNjdD4NCiAgICAgICAgPElkPg0KICAgICAgICAgIDxJQkFOPkZJODUyOTUwMTgwMDAzMDU3NDwvSUJBTj4NCiAgICAgICAgPC9JZD4NCiAgICAgIDwvRGJ0ckFjY3Q+DQogICAgICA8RGJ0ckFndD4NCiAgICAgICAgPEZpbkluc3RuSWQ+DQogICAgICAgICAgPEJJQz5OREVBRklISDwvQklDPg0KICAgICAgICA8L0Zpbkluc3RuSWQ+DQogICAgICA8L0RidHJBZ3Q+DQogICAgICA8Q2hyZ0JyPlNMRVY8L0NocmdCcj4NCiAgICAgIDwhLS0NCioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioNCjEuIFNFUEEgVmlpdHRlZWxsaW5lbiBTRVBBLXRpbGlzaWlydG8NCioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioNCi0tPg0KICAgICAgPENkdFRyZlR4SW5mPg0KICAgICAgICA8UG10SWQ+DQogICAgICAgICAgPEVuZFRvRW5kSWQ+MjAwOTA4MjEtRTAwMDAwMjwvRW5kVG9FbmRJZD4NCiAgICAgICAgPC9QbXRJZD4NCiAgICAgICAgPEFtdD4NCiAgICAgICAgICA8SW5zdGRBbXQgQ2N5PSJFVVIiPjEwMC4wMTwvSW5zdGRBbXQ+DQogICAgICAgIDwvQW10Pg0KICAgICAgICA8Q2R0ckFndD4NCiAgICAgICAgICA8RmluSW5zdG5JZD4NCiAgICAgICAgICAgIDxCSUM+QkFOS0ZJSEg8L0JJQz4NCiAgICAgICAgICA8L0Zpbkluc3RuSWQ+DQogICAgICAgIDwvQ2R0ckFndD4NCiAgICAgICAgPENkdHI+DQogICAgICAgICAgPE5tPkNyZWRpdG9yIENvbXBhbnk8L05tPg0KICAgICAgICAgIDxQc3RsQWRyPg0KICAgICAgICAgICAgPEFkckxpbmU+TGlubmFua2F0dSAyMjwvQWRyTGluZT4NCiAgICAgICAgICAgIDxBZHJMaW5lPjIwMTAwIFR1cmt1PC9BZHJMaW5lPg0KICAgICAgICAgICAgPEN0cnk+Rkk8L0N0cnk+DQogICAgICAgICAgPC9Qc3RsQWRyPg0KICAgICAgICA8L0NkdHI+DQogICAgICAgIDxDZHRyQWNjdD4NCiAgICAgICAgICA8SWQ+DQogICAgICAgICAgICA8SUJBTj5GSTYzMjk1MDE4MDAwMjA1ODI8L0lCQU4+DQogICAgICAgICAgPC9JZD4NCiAgICAgICAgPC9DZHRyQWNjdD4NCiAgICAgICAgPFJtdEluZj4NCiAgICAgICAgICA8U3RyZD4NCiAgICAgICAgICAgIDxDZHRyUmVmSW5mPg0KICAgICAgICAgICAgICA8Q2R0clJlZlRwPg0KICAgICAgICAgICAgICAgIDxDZD5TQ09SPC9DZD4NCiAgICAgICAgICAgICAgPC9DZHRyUmVmVHA+DQogICAgICAgICAgICAgIDxDZHRyUmVmPjAwMDAwMDAwMDAwMDAwMDAwMTIzPC9DZHRyUmVmPg0KICAgICAgICAgICAgPC9DZHRyUmVmSW5mPg0KICAgICAgICAgIDwvU3RyZD4NCiAgICAgICAgPC9SbXRJbmY+DQogICAgICA8L0NkdFRyZlR4SW5mPg0KICAgIDwvUG10SW5mPg0KICA8L3BhaW4uMDAxLjAwMS4wMj4NCjwvRG9jdW1lbnQ+")
        end
      end
      response.application_response.transaction_count.should == 1
      response.response_header.response_code.should == "00"
      response.response_header.response_text.should == "OK."
    end

    it "should raise error #23 when ServiceId is not present" do
      lambda {
        response = VCR.use_cassette('upload_file_error') do
          response = client.request :upload_file do |header, request|
            header.receiver_id      = 123456789
            request.customer_id     = 162355330
            request.target_id       = "11111111A1"
            # request.service_id      = "111111111"
            request.file_type       = "CNFTC000S"
            request.user_filename   = "TEST.TXT"
            request.content         = "TEST"
          end
        end
      }.should raise_error(
        Nordea::FileTransfer::Error,
        "Content processing error. Download feedback. (#23)"
      )
    end
  end
end
