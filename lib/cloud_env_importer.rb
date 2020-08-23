class CloudEnvImporter
  include HTTParty
  base_uri  'http://metadata.google.internal/computeMetadata/v1/project/attributes/'

  def get_request(service_url = '')
    headers = {"Metadata-Flavor": "Google"}
    begin
      self.class.get(service_url, {headers: headers})
    rescue
      p "I'm on Heroku Environment"
    end
  end

  def get_env_vars
    keys = get_request.parsed_response.split("\n") - ['ssh-keys']
    env_vars = {}
    keys.each do |key|
      env_vars[key] = get_request("/#{key}").parsed_response
    end
    env_vars
  end

  def add_cloud_vars_to_env
    ENV.update get_env_vars
  end

  # def get_twilio_sid
  #   get_request('/TWILIO_ACCOUNT_SID', headers: header)
  # end
end