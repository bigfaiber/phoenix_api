class StaticController < ApplicationController

  def average_interest
    average =  Project.average_interest
    render json: {
      data: {
        interest: average
      }
    }
  end
end
