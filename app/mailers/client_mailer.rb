  class ClientMailer < ApplicationMailer

  def code(user)
    options = {
      :subject => 'Codigo de confirmacion',
      :email => user.email,
      :name => "#{user.name} #{user.lastname}",
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
    options = {
      :subject => 'Bienvenido a Phoenix',
      :email => user.email,
      :name => "#{user.name} #{user.lastname}",
      :global_merge_vars => [
        {
          name: 'name',
          content: user.name
        },
        {
          name: 'lastname',
          content: user.lastname
        }
      ],
      template: 'WELCOME'
    }
    mandrill_send(options)
  end

  def admin_account(name,lastname,password,email)
    options = {
      :subject => 'Nueva cuenta de administrador',
      :email => email,
      :name => "#{name} #{lastname}",
      :global_merge_vars => [
        {
          name: 'name',
          content: name
        },
        {
          name: 'lastname',
          content: lastname
        },
        {
          name: 'pass',
          content: password
        }
      ],
      template: 'NEW_ADMIN'
    }
    mandrill_send(options)
  end

  def project_approved(user)
    options = {
      :subject => 'Proyecto Aprobado',
      :email => user.email,
      :name => "#{user.name} #{user.lastname}",
      :global_merge_vars => [
        {
          name: 'name',
          content: user.name
        },
        {
          name: 'lastname',
          content: user.lastname
        }
      ],
      template: 'PROJECT_APPROVED'
    }
    mandrill_send(options)
  end

  def client_like(user)
    options = {
      :subject => "Inversionista Interesado",
      :email => user.email,
      :name => "#{user.name} #{user.lastname}",
      :global_merge_vars => [
        {
          name: 'name',
          content: user.name
        },
        {
          name: 'lastname',
          content: user.lastname
        }
      ],
      template: 'CLIENT_LIKE'
    }
    mandrill_send(options)
  end

  def clinet_match(user)
    options = {
      :subject => 'Match Proyecto',
      :email => user.email,
      :name => "#{user.name} #{user.lastname}",
      :global_merge_vars => [
        {
          name: 'name',
          content: user.name
        },
        {
          name: 'lastname',
          content: user.lastname
        }
      ],
      template: 'CLIENT_MATCH'
    }
    mandrill_send(options)
  end

  def investor_match(user)
    options = {
      :subject => 'Match Proyecto',
      :email => user.email,
      :name => "#{user.name} #{user.lastname}",
      :global_merge_vars => [
        {
          name: 'name',
          content: user.name
        },
        {
          name: 'lastname',
          content: user.lastname
        }
      ],
      template: 'INVESTOR_MATCH'
    }
    mandrill_send(options)
  end

  def investor_match_maximum
    options = {
      :subject => 'Match Proyecto',
      :email => user.email,
      :name => "#{user.name} #{user.lastname}",
      :global_merge_vars => [
        {
          name: 'name',
          content: user.name
        },
        {
          name: 'lastname',
          content: user.lastname
        }
      ],
      template: 'INVESTOR_MATCH_MAXIMUM'
    }
    mandrill_send(options)
  end

  def new_password(resource, token)
    options = {
      :subject => "Solicitud Nueva Contrasena",
      :email => resource.email,
      :name => "#{resource.name} #{resource.lastname}",
      :global_merge_vars => [
        {
          name: 'name',
          content: resource.name
        },
        {
          name: 'lastname',
          content: resource.lastname
        },
        {
          name: 'new_password',
          content: "https://www.phx.com.co/new-password?email=#{resource.email}&token=#{token}&type=#{resource.class.name}"
        }
      ],
      template: 'NEW_PASSWORD'
    }
    mandrill_send(options)
  end

  def investor_not_chosen(investor,project)
    options = {
      :subject => "Sigue intentando",
      :email => investor.email,
      :name => "#{investor.name} #{investor.lastname}",
      :global_merge_vars => [
        {
          name: 'name',
          content: investor.name
        },
        {
          name: 'lastname',
          content: investor.lastname
        },
        {
          name: 'project',
          content: project.dream
        }
      ],
      template: 'INVESTOR_NOT_CHOSEN'
    }
    mandrill_send(options)
  end

  def new_password_confirmation(user, pass)
    options = {
      :subject => "Confirmacion Nueva Contrasena",
      :email => user.email,
      :name => "#{user.name} #{user.lastname}",
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
          name: 'new_password',
          content: pass
        }
      ],
      template: 'NEW_PASSWORD_CONFIRMATION'
    }
    mandrill_send(options)
  end

  private
  def mandrill_send(opts={})
    message = {
      :subject=> "#{opts[:subject]}",
      :from_name=> "Phoenix team",
      :from_email=>"operaciones@phx.com.co",
      :to=>
            [{"name"=>"#{opts[:name]}",
                "email"=>"#{opts[:email]}",
                "type"=>"to"}],
      :global_merge_vars => opts[:global_merge_vars]
      }
    begin
      sending = MANDRILL.messages.send_template opts[:template], [], message
    rescue Mandrill::Error => e
      Rails.logger.debug(e)
    end
  end

end
