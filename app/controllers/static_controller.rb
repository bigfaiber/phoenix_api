class StaticController < ApplicationController

  def average_interest
    if Project.all.size > 0
      average =  Project.average_interest
    end
    average ||= 1.5
    render json: {
      data: {
        interest: average
      }
    }
  end
end
