#Production
server '35.196.49.244', port: 22, roles: [:web, :app, :db], primary: true

set :nginx_use_ssl, true