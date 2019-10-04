#Testing
server '35.196.13.213', port: 22, roles: [:web, :app, :db], primary: true
set :nginx_use_ssl, false