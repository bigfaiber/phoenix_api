# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
a = Admin.new(name: 'Carlos', lastname: 'Phoenix', email: 'carlos@phx.com.co',password: 'Tikeromm1', password_confirmation: 'Tikeromm1')
a.save
b = Admin.new(name: 'Andres', lastname: 'Gutierrez', email: "agutierrezt@slabcode.com", password: 'Gutierrez1003739139',password_confirmation:'Gutierrez1003739139')
b.save