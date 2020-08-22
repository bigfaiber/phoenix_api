class MessageSender
  def self.send_message(code,phone)
    new.send_message(code, phone)
  end

  def initialize
    account_sid = system("curl 'http://metadata.google.internal/computeMetadata/v1/project/attributes/TWILIO_ACCOUNT_SID' -H 'Metadata-Flavor: Google'")
    auth_token  = system("curl 'http://metadata.google.internal/computeMetadata/v1/project/attributes/TWILIO_AUTH_TOKEN' -H 'Metadata-Flavor: Google'")
    @client = Twilio::REST::Client.new(account_sid, auth_token)
  end

  def send_message(code,phone)
    @client.messages.create(
      from:  system("curl 'http://metadata.google.internal/computeMetadata/v1/project/attributes/SENDER_PHONE' -H 'Metadata-Flavor: Google'"),
      to:    phone,
      body:  "Su codigo de verificacon es: \n #{code}"
    )
  end
end
