# Ruby client for Nordea FileTransfer

```
         Payload                ApplicationRequest           SOAP Envelope
   +-------------------+     +---------------------+     +--------------------+
 C |                   |     |                     |     |                    |
 O |   Content         |     |   Customer ID       |     |    SOAP Header     |
 R |                   |     |   Timestamp         |     | +----------------+ |
 P |                   |     |   Environment       |     | | Signature      | |
 O |                   |     |   Target ID         |     | | ...            | |
 R |                   |     |   Encryption        |     | +----------------+ |
 A |                   |     |   Compression       |     |                    |
 T |                   |     |   Software ID       |     |                    |
 E |                   |     |   File Type         |     |                    |
   |                   |     | +-----------------+ |     |                    |
 L |                   +-------> Content Base64  | |     |     SOAP Body      |
 E |                   |     | +-----------------+ |     | +----------------+ |
 G |                   |     |                     |     | | Request Header | |
 A |                   |     |                     +-------> AppReq Base64  | |
 C |                   |     |                     |     | +----------------+ |
 Y |                   |     |                     |     |                    |
   +-------------------+     +---------------------+     +--------------------+

   1.          | 2.      | 3.                   | 4.        | 5.
   Generate    | Import  | Builds XML structure | Transport | Creates WS Message
   Legacy data | Payload | and signs it         | App.Req.  | and signs it

```

## Getting Started

```bash
$ gem install nordea-filetransfer
```

## Usage

```ruby
require "noredea/file_transfer"

client = Nordea::FileTransfer::Client.new(
  :cert_file => "path/to/cert.pem",
  :private_key_file => "path/to/key.pem"
)
```

### Get User Info

```ruby
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
```

### Download File List

```ruby
response = client.request(:download_file_list) do |r|
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
```

### Download File

```ruby
response = client.request(:download_file) do |r|
  r.request_header.attributes = {
    :sender_id   => 11111111,
    :request_id  => 1234,
    :timestamp   => Time.now,
    :language    => "EN",
    :user_agent  => "Ruby",
    :receiver_id => 123456789
  }
  r.application_request.attributes = {
    :customer_id      => 162355330,
    :command          => "DownloadFile",
    :timestamp        => Time.now,
    :environment      => "PRODUCTION",
    :file_references  => ["1320120312210394"],
    :target_id        => "11111111A1",
    :execution_serial => "001",
    :software_id      => "Ruby",
    :file_type        => "VKEUR"
  }
end
```

## References

* [Nordea: Web Services Security and Communication (PDF)](http://www.nordea.fi/sitemod/upload/root/fi_org/liite/e/yritys/pdf/web_services_ohjelmistotalot.pdf)
* [Nordea: Web Services (PDF)](http://www.nordea.fi/sitemod/upload/root/fi_org/liite/e/yritys/pdf/web_services.pdf)
* [Nordea: File Transfer Service Description (PDF)](http://www.nordea.fi/sitemod/upload/Root/fi_org/liite/e/yritys/pdf/erasiir.pdf)
* [Nordea: File Transfer Instructions (HTML)](http://www.nordea.fi/Corporate+customers/Payments+and+cards/Advice+on+payments+and+cards/Instructions/1433022.html)
* [Nordea: File Transfer Example files (HTML)](http://www.nordea.fi/Corporate+customers/Payments+and+cards/Advice+on+payments+and+cards/Example+files/1466002.html)
* [Nordea: File Transfer WSDL (XML)](https://filetransfer.nordea.com/services/CorporateFileService?wsdl)
* [Nordea: File Transfer WSDL: XSD1 (XML)](https://filetransfer.nordea.com/services/CorporateFileService.xsd1.xsd)
* [Nordea: File Transfer WSDL: XSD2 (XML)](https://filetransfer.nordea.com/services/CorporateFileService.xsd2.xsd)
* [Nordea: File Transfer WSDL: ApplicationRequest.xsd (XML)](http://www.nordea.fi/sitemod/upload/root/fi_org/liite/ApplicationRequest.xsd)
* [Nordea: File Transfer WSDL: ApplicationResponse.xsd (XML)](http://www.nordea.fi/sitemod/upload/root/fi_org/liite/ApplicationResponse.xsd)
