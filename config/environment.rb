# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!
CloudEnvImporter.new.add_cloud_vars_to_env