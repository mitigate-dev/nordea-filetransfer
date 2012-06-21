# Ruby client for Nordea FileTransfer

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

response.response_header
response.application_response
```

## References

* [Nordea: Web Services Security and Communication](http://www.nordea.fi/sitemod/upload/root/fi_org/liite/e/yritys/pdf/web_services_ohjelmistotalot.pdf)
* [Nordea: Web Services](http://www.nordea.fi/sitemod/upload/root/fi_org/liite/e/yritys/pdf/web_services.pdf)
* [Nordea: File Transfer Instructions](http://www.nordea.fi/Corporate+customers/Payments+and+cards/Advice+on+payments+and+cards/Instructions/1433022.html)
* [Nordea: File Transfer Example files](http://www.nordea.fi/Corporate+customers/Payments+and+cards/Advice+on+payments+and+cards/Example+files/1466002.html)
* [Nordea: File Transfer WSDL](https://filetransfer.nordea.com/services/CorporateFileService?wsdl)
* [Nordea: ApplicationRequest.xsd](http://www.nordea.fi/sitemod/upload/root/fi_org/liite/ApplicationRequest.xsd)
* [Nordea: ApplicationResponse.xsd](http://www.nordea.fi/sitemod/upload/root/fi_org/liite/ApplicationResponse.xsd)
