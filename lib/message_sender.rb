class MessageSender
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
      from:  "+18557824012",
      to:    phone,
      body:  "Su codigo de verificacon es: \n #{code}"
    )
  end
end
