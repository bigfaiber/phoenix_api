class StaticController < ApplicationController

  def average_interest
    average =  Project.average_interest
    average ||= 1.5
    render json: {
      data: {
        interest: average
      }
    }
  end
end
