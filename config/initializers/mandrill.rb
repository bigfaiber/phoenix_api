require 'mandrill'

# Use an environment variable instead of placing the key in source code
# url = 'http://metadata.google.internal/computeMetadata/v1/project/attributes/MAILCHIMP_KEY'
# header = {"Metadata-Flavor": "Google"}
CloudEnvImporter.new.add_cloud_vars_to_env
MANDRILL = Mandrill::API.new(ENV['MAILCHIMP_KEY'])
