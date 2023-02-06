# Author: Harry Brink
# Date: 05/02/2023
# Charging Session Class Object to represent an individual charging session of an owners vehicle.

# It is assumed that each user can only have one vehicle as there is no id field present in the vehicle json file.

# Reasoning: (I wouldn't usually put a reasoning comment in a file but just so I remember why I did certain things for the future.) Core object in the app. Stores the composed object meter values and is the main object for data processing in an owners charging session. 

class ChargingSession

  
  def initialize(id)
    @id = id
    @total_charge = 0.0
    @total_rate_charge = 0.0
    @meter_values = Array.new
  end

  def addMeterValue(meter_value)
    @meter_values.push(meter_value)

    if (meter_value.amount_of_charge() > @total_charge)
      @total_charge = meter_value.amount_of_charge()
    end
    @total_rate_charge += meter_value.rate_of_charge()
  end

  # Generate the number of meter values in the charging session.
  def num_meter_values()
    return @meter_values.length()
  end

  #Generates the ChargingSession instance as a usable json object.
  def generateJson()
    return {
      id: @id,
      charge_amount: (@total_charge / 1000),
      total_average_rate_of_charge: (@total_rate_charge / 1000),
      num_meter_values: num_meter_values()
    }
  end

  # Getters and Setters
  attr_reader :id
  attr_accessor :total_charge
  attr_accessor :meter_values
  # def id()
  #   @id
  # end

  # def total_charge()
  #   @total_charge
  # end

  # def meter_values()
  #   @meter_values
  # end
end
