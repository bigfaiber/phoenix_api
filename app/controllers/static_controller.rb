class StaticController < ApplicationController

  def average_interest
    average =  Project.average_interest
    if average == 0
      average = 1.5
    end
    average ||= 1.5
    render json: {
      data: {
        interest: average
      }
    }
  end
end
