class UpdateInteresLevelForClients < ActiveRecord::Migration[5.1]
  def change
    Client.find_each do |client|
      projects = Project.where(client_id: client.id).where(finished: true)
      if projects.count > 0
        average_time = 0
        average_percentage = 0
        projects.each do |project|
          time = project.receipts.count
          average_time = average_time + time
          average_percentage = average_percentage + ((100.0 * project.receipts.where(delay: 0).count) / time )
        end
        average_time = average_time / projects.count
        average_percentage = average_percentage / projects.count
        if average_time > 12
          if average_percentage > 99 
            client.interest_level = 4
            client.save
          end  
        elsif average_time > 9
          if average_percentage > 75 
            client.interest_level = 3
            client.save
          end 
        elsif average_time > 6
          if average_percentage > 50 
            client.interest_level = 2
            client.save
          end 
        elsif average_time > 3
          if average_percentage > 25 
            client.interest_level = 1
            client.save
          end 
        end
      end
    end
  end
end
