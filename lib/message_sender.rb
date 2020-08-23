class MessageSender

  # base_url = 'http://metadata.google.internal/computeMetadata/v1/project/attributes/'
  # header = {"Metadata-Flavor": "Google"}
  # ENV['TWILIO_ACCOUNT_SID'] |= HTTParty.get(base_url + 'TWILIO_ACCOUNT_SID', headers: header)
  # ENV['TWILIO_AUTH_TOKEN'] |= HTTParty.get(base_url + 'TWILIO_AUTH_TOKEN', headers: header)
  # ENV['SENDER_PHONE'] |= HTTParty.get(base_url + 'SENDER_PHONE', headers: header)

  def self.send_message(code,phone)
    new.send_message(code, phone)
  end

  def initialize

    account_sid = ENV['TWILIO_ACCOUNT_SID']
    auth_token  = ENV['TWILIO_AUTH_TOKEN']
    @client = Twilio::REST::Client.new(account_sid, auth_token)
  end

  def send_message(code,phone)
    @client.messages.create(
      from:  ENV['SENDER_PHONE'],
      to:    phone,
      body:  "Su codigo de verificacon es: \n #{code}"
    )
  end
end
