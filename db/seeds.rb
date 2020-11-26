#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# a = Admin.new(name: 'Carlos', lastname: 'Phoenix', email: 'carlos@phx.com.co',password: 'Tikeromm1', password_confirmation: 'Tikeromm1')
# a.save
# b = Admin.new(name: 'Andres', lastname: 'Gutierrez', email: "agutierrezt@slabcode.com", password: 'Gutierrez1003739139',password_confirmation:'Gutierrez1003739139')
# b.save
# 

# "eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MywidHlwZSI6IkNsaWVudCIsImV4cCI6MTYwNjQyNzk0N30.t4QJLnziB09wsKnpDneqMtrq6F5hwQoPQVWEX1Pr9yQ"
admin_test = Admin.create_with(name: 'Mou', lastname: 'Phoenix',password: 'test1234', password_confirmation: 'test1234').find_or_create_by!(email: 'mou@email.com')


client1 = Client.create_with(name: 'Client', lastname: 'Phoenix', identification: '1212121212', phone: '3003000000', address: 'here and there', birthday: Date.new, email: 'client@email.com', city: 'Bogotá', password: 'test1234', password_confirmation: 'test1234', code: '1234', code_confirmation:true, rent: true, rent_payment: '1000000', people: 1, education: 2, marital_status: 0, rent_tax: true, employment_status: 1, terms_and_conditions: true, new_client: false, rating: 0.0, token: '1234123412341234', job_position: 'Vendedor', patrimony: '25000000', max_capacity: '10000000', current_debt: '5000000', income: '3000000', payment_capacity: '500000', step: 4, global: 50, client_type: 3, interest_level: 3, career: 10, technical_career: 'Vendedor', household_type: 0, market_expenses: '400000', transport_expenses: '150000', public_service_expenses: '250000', bank_obligations: '250000', real_estate: false, payments_in_arrears: true, payments_in_arrears_value: '500000', payments_in_arrears_time: '36').find_or_create_by!(identification: '1212121212')

investor1 = Investor.create_with(name: 'Investor', lastname: 'Phoenix', identification: '2929292929', phone: '3003000001', address: 'there and here', birthday: Date.new, email: 'investor@email.com', city: 'Bogotá', password: 'test1234', password_confirmation: 'test1234', code: '4321', code_confirmation: true, employment_status: 1, education: 2, rent_tax: true, terms_and_conditions: true, new_investor: false, money_invest: 10000000, month: 24, monthly_payment: 500000, profitability: 3000000, token: '432343243242342', career: 3).find_or_create_by!(identification: '2929292929')

project1 = Project.create_with(dream: 'comprar un carro bibip', description: 'comprar un vehículo para transporte pesonal', money: 35000000, monthly_payment: 500000, month: 36, approved: true, warranty: 0, interest_rate: 1.5, investor_id: investor1.id, account_id: '1212121212', client_id: client1.id, initial_payment: Date.new + 5.day, new_project: false, approved_date: Date.new, code: '1234', finished: false, matched: true).find_or_create_by!(dream: 'comprar un carro bibip')

puts 'seeds created'