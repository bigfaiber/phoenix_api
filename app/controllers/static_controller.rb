class StaticController < ApplicationController

  def average_interest
    average =  Project.average_interest
    average ||= 1.5
    if average == 0
      average = 1.5
    end
    render json: {
      data: {
        interest: average
      }
    }
  end
  
  def projects_values_interest
    average_interest =  Project.average_interest
    average_interest =  1.5 if average_interest.zero?
    
    active_projects = Project.active_projects
    active_projects =  30 if active_projects.zero?
    
    active_loans = Project.active_loans
    active_loans = 1499388379 if active_loans.zero?
    
    render json: { 
        interest: average_interest,
        projects: active_projects,
        active_loans: active_loans
      }, status: :ok
  end
end
