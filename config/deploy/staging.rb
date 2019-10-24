#Staging
server '34.74.4.241', port: 22, roles: [:web, :app, :db], primary: true
set :nginx_use_ssl, false
set :stage,           :staging
set :rails_env, "development"
set :branch,        :master
