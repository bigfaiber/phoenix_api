class AuthenticateCommand
  prepend SimpleCommand
  attr_accessor :email,:password, :type

  def initialize(email,password, type)
    @email = email
    @password = password
    @type = type
  end

  def call
    JsonWebToken.encode(playload: {id: find.id, type: @type }) if find
  end

  private
  def find
    case @type
    when "Admin"
      find = Admin.by_email(@email)
    when "Client"
      find = Client.by_email(@email)
    when "Investor"
      find = Investor.by_email(@email)
    end
    return find if find && find.authenticate(@password)
    errors.add :authentication, 'invalid credentials'
    nil
  end
end
