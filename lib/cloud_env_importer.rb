class CloudEnvImporter
  include HTTParty
  base_uri  'http://metadata.google.internal/computeMetadata/v1/project/attributes/'

  def get_request(service_url = '')
    headers = {"Metadata-Flavor": "Google"}
    begin
      self.class.get(service_url, {headers: headers})
    rescue
      nil
    end
  end

  def get_env_vars
    keys = get_request&.parsed_response&.split("\n") - ['ssh-keys']
    env_vars = {}
    keys.each{ |key| env_vars[key] = get_request("/#{key}")&.parsed_response} if keys
    env_vars
  end

  def add_cloud_vars_to_env
    gcloud_metadata = get_env_vars
    ENV.update(gcloud_metadata) if gcloud_metadata
  end

  # def get_twilio_sid
  #   get_request('/TWILIO_ACCOUNT_SID', headers: header)
  # end
end