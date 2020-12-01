class AuthenticateCommand
  prepend SimpleCommand
  attr_accessor :email,:password, :type

  def initialize(email,password, type)
    @email = email
    @password = password
    @type = type
  end

  def call
    JsonWebToken.encode(payload: {id: find.id, type: @type }) if find
  end

  private
  def find
    types = ['Admin', 'Client', 'Investor']
    user = nil
    types.each do |type|
      user = Kernel.const_get(type).by_email(@email)
      break if user
    end
    return user if user && user.authenticate(@password)
    errors.add :authentication, 'invalid credentials'
    nil
  end
end
