require 'mandrill'

# Use an environment variable instead of placing the key in source code
MANDRILL = Mandrill::API.new(ENV['MAILCHIMP_KEY'])
