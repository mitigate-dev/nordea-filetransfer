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

## Installation

```bash
$ gem install nordea-filetransfer
```

## Usage

```ruby
require "noredea/file_transfer"

client = Nordea::FileTransfer::Client.new(
  :cert_file        => "path/to/cert.pem",
  :private_key_file => "path/to/key.pem",
  :sender_id        => 11111111,
  :language         => "EN",
  :environment      => "PRODUCTION"
  :user_agent       => "Ruby",
  :software_id      => "Ruby"
)

response = client.request :get_user_info do |header, request|
  header.receiver_id  = 123456789
  request.customer_id = 162355330
end

response.response_header
# => Nordea::FileTransfer::ResponseHeader

response.application_response
# => Nordea::FileTransfer::ApplicationResponse
```

### Get User Info

> The service will provide the client with information of
> authorized user file types and service ID’s.

```ruby
response = client.request :get_user_info do |header, request|
  header.receiver_id  = 123456789
  request.customer_id = 162355330,
end

response.application_response.user_file_types
# => [Nordea::FileTransfer::UserFileType, ...]
```

### Download File List

> The service will provide the client with a list of
> files that are available for download from Nordea.

```ruby
response = client.request :download_file_list do |header, request|
  header.receiver_id  = 123456789
  request.customer_id = 162355330
  request.status      = "ALL"
  request.target_id   = "11111111A1"
  request.file_type   = "NDCORPAYL"
end

response.application_response.file_descriptors
# => [Nordea::FileTransfer::FileDescriptor, ...]
```

### Download File

> The service will provide the client with requested files.
> Downloadable files can be checked by DownloadFileList –service. The query may be:
> 
> - download single file
> - download multiple files
> - download all files of type
> - download all files

```ruby
response = client.request :download_file do |header, request|
  header.receiver_id      = 123456789
  request.customer_id     = 162355330
  request.file_references = ["2012082621423418"]
  request.target_id       = "11111111A1"
  request.file_type       = "VKEUR"
end

response.application_response.content
# => VK0100020120821154650Listakurssit alle 40.000 eur maksuille 21.08.12 15:35
#    VK01001199901010730000001EUREUR00000100000000000010000000000001000000000000100000000000010000000+K000000000K
#    VK01001201208211535490001USDEUR00000124280000000012578000000001227800000000127180000000012138000+K000000000K
#    VK01001201208211535470001JPYEUR00009881000000001008100000000096810000000010252000000000951000000+K000000000K
#    ...
```

### Upload File (TODO)

> The Service will provide the transport of the customers file to Nordea.
> The response from Nordea will  be a transport acknowledgement with details
> regarding the status of the transport.
> 
> Backend system will process the files in batch mode. This means that the only
> verification of a file transfer, successful or not, will be a transfer
> acknowledgement. The client will not usually receive any other notification and
> the result must be retrieved with a new call later.

```ruby
response = client.request :upload_file do |header, request|
  header.receiver_id      = 123456789
  request.customer_id     = 162355330
  request.target_id       = "11111111A1"
  request.service_id      = "0012345678"
  request.file_type       = "CNFTC000S"
  request.user_filename   = "TEST.TXT"
  request.content         = "..."
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
