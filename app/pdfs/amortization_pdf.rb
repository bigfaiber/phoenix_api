class AmortizationPdf < Prawn::Document

  def initialize(project)
    super()
    @project = project
    generate_table
  end

  def generate_table
    move_down 10
    font("Times-Roman") do
      text "TABLA DE AMORTIZACION", :align => :center, :size => 15, :style => :bold
    end
    move_down 5
    font("Times-Roman") do
      text "#{@project.dream}", :align => :center, :size => 12
    end
    move_down 5
    font("Times-Roman") do
      text "#{@project.client.name} #{@project.client.lastname}", :align => :center, :size => 12
    end
    font("Times-Roman") do
      text "#{@project.client.identification}", :align => :center, :size => 12
    end
    move_down 5
    font("Times-Roman") do
      text "Interes: #{@project.interest_rate}", :align => :center, :size => 12
    end
    move_down 15
    period = 0
    is_creating = true
    money_temp = @project.money + 0.0
    data = [["periodo","intereses","abono capital","cuota a pagar","saldo"]]
    data += [["#{period}","","","","$ #{price(@project.money)}"]]
    while is_creating
      period = period + 1
      interest_temp = (@project.interest_rate/100.0)*money_temp
      payment = @project.fee - interest_temp
      if money_temp >= @project.fee
        money_temp = money_temp - payment
        data += [["#{period}","$ #{price(interest_temp.round)}","$ #{price(payment.round)}","#{price(@project.fee)}","$ #{price(money_temp.round)}"]]
      else
        data += [["#{period}","$ #{price(interest_temp.round)}","$ #{price(money_temp.round)}","#{price(money_temp.round + interest_temp.round)}","$ 0"]]
        money_temp = 0
      end

      if money_temp == 0
        is_creating = false
      end
    end

    table(data,header: true)
  end

  def price(num)
    num.to_s.gsub('.00','').reverse.scan(/(\d*\.\d{1,3}|\d{1,3})/).join(',').reverse
  end


end
