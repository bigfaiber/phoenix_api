class MessageSender
  def self.send_message(code,phone)
    new.send_message(code, phone)
  end

  def initialize
    account_sid = "ACa809307c884926237732fd472178bcb5"
    auth_token  = "c87263bc9ace638802200644ded3f4eb"
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
