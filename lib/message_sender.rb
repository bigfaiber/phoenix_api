class MessageSender
  def self.send_message(code,phone)
    new.send_message(code, phone)
  end

  def initialize
    account_sid = "AC255871026d07380b58cf165418be3268"
    auth_token  = "a910ada06ab7f284fb4d189c5349cf80"
    @client = Twilio::REST::Client.new(account_sid, auth_token)
  end

  def send_message(code,phone)
    @client.messages.create(
      from:  "+16464900608",
      to:    phone,
      body:  "Su codigo de verificacon es: \n #{code}"
    )
  end
end
