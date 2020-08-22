require 'mandrill'

# Use an environment variable instead of placing the key in source code
MANDRILL = Mandrill::API.new(system"curl 'http://metadata.google.internal/computeMetadata/v1/project/attributes/MAILCHIMP_KEY' -H 'Metadata-Flavor: Google'")


