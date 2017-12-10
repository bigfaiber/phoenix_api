class ClientMailer < ApplicationMailer

  def welcome(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Phoenix')
  end

  def admin_account(name,lastname,password,email)
    @name = name
    @lastname = lastname
    @pass = password
    mail(to: email, subject: 'Welcome to Phoenix')
  end

  def project_approved(email)
    @email = email
    mail(to: email, subject: 'Project approved')
  end

  def clinet_match(email)
    mail(to: email, subject: 'Match')
  end

  def investor_match(email)
    mail(to: email, subject: 'Match')
  end
end
