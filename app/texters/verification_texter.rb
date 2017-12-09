class VerificationTexter < Textris::Base
  default :from => ENV["TWILIO_NUMBER"]

  def verification_code(code, number)
    @code = code
    text :to => number
  end
end
