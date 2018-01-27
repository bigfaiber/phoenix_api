require 'mandrill'

class ClientMailer < ApplicationMailer

  def code(user)
    options = {
      :subject => 'Codigo de confirmacion',
      :email => user.email,
      :name => "user.name",
      :global_merge_vars => [
        {
          name: 'name',
          content: user.name
        },
        {
          name: 'lastname',
          content: user.lastname
        },
        {
          name: 'code',
          content: user.code
        }
      ],
      template: 'PHX_CODE'
    }
    mandrill_send(options)
  end

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

  def new_password(resource, token)
    @resource = resource
    @token = token
    mail(to: resource.email, subject: 'Reset password')
  end

  def new_password_confirmation(email, pass)
    @pass = pass
    mail(to: email, subject: 'New password')
  end

  private
  def mandrill_send(opts={})
    message = {
      :subject=> "#{opts[:subject]}",
      :from_name=> "non_reply@phx.com.co",
      :from_email=>"non_reply@phx.com.co",
      :to=>
            [{"name"=>"#{opts[:name]}",
                "email"=>"#{opts[:email]}",
                "type"=>"to"}],
      :global_merge_vars => opts[:global_merge_vars]
      }
    mandrill = Mandrill::API.new 'wz2YKz7YFKjJdwymttjL1g'
    sending = mandrill.messages.send_template opts[:template], [], message
    rescue Mandrill::Error => e
      Rails.logger.debug("#{e.class}: #{e.message}")
      raise
  end

end
