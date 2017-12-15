# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
a = Admin.new(name: 'Admin', lastname: 'Phoenix', email: 'admin@phx.com.co',password: '0123456789', password_confirmation: '0123456789')
a.save
