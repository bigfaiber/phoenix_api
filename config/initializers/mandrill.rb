require 'mandrill'

# Use an environment variable instead of placing the key in source code
url = 'http://metadata.google.internal/computeMetadata/v1/project/attributes/MAILCHIMP_KEY'
header = {"Metadata-Flavor": "Google"}
MANDRILL = Mandrill::API.new(HTTParty.get(url, headers: header))


