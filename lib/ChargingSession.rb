# Author: Harry Brink
# Date: 05/02/2023
# Charging Session Class Object to represent an individual charging session of an owners vehicle.

# It is assumed that each user can only have one vehicle as there is no id field present in the vehicle json file.

# Reasoning: (I wouldn't usually put a reasoning comment in a file but just so I remember why I did certain things for the future.) Core object in the app. Stores the composed object meter values and is the main object for data processing in an owners charging session. 

class ChargingSession

  
  def initialize(id, user)
    @id = id
    @user = user
    @total_charge = 0
    @total_rate_charge = 0
    @vehicle = ''
    @meter_values = Array.new
  end

  def addMeterValue(meter_value)
    @meter_values.push(meter_value)
    @total_charge += meter_value.amount_of_charge()
    # TODO add to total_rate_of_charge somehow....
  end

  # Return the average of meter all meter values. If no meter values have been recorded return zero. 
  def average_rate_charge()
    begin
      return @total_rate_charge / this.num_meter_values
    rescue
      return 0
    end
  end

  # Generate the number of meter values in the charging session.
  def num_meter_values()
    return @num_meter_values.length
  end


  #Generates the ChargingSession instance as a usable json object.
  def generateJson()
    return {
      id: @id,
      total_charge: @total_charge,
      average_rate_charge: @average_rate_charge,
      user: @user
    }
  end

  # Getters and Setters
  def id()
    @id
  end

  def user()
    @user
  end

  def vehicle()
    @vehicle
  end

  def total_charge()
    @total_charge
  end
end
