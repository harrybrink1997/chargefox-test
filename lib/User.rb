# Author: Harry Brink
# Date: 05/02/2023
# User Class Object to represent an individual charging session of an owners vehicle.

# Reasoning: (I wouldn't usually put a reasoning comment in a file but just so I remember why I did certain things for the future.) Users can have multiple charging sessions and other data - since users are the centre of the app it makes sense to have a user object which holds all their charging sessions and vehicles for easy access and process during runtime. 

class User

  
  def initialize(name, vehicle)
    @name = name
    @vehicle = vehicle
    @sessions = {}
  end

  # Generates JSON formatted data for class
  # Inputs: Void
  # Outputs: Hashmap instance_json_data
  def generateJson()
    session_data = generateSessionData()

    return {
      user: @name,
      vehicle: @vehicle.generateJson()[:vehicle],
      average_rate_of_charge: format('%0.2f', session_data[:average_rate_of_charge].to_s) + " kW",
      total_charge_amount: format('%0.2f', session_data[:total_charge_amount].to_s) + " kWh",
      session_count: @sessions.length.to_s
    }
  end

  # Aggregates all the user session data, calculating the total charge accumulated over all chargin sessions and the average rate of charge.
  # Inputs: Void
  # Outputs: Hashmap session_data
  def generateSessionData()

    session_data = {
      total_charge_amount: 0,
      average_rate_of_charge: 0
    }

    total_rate_charge = 0
    num_meter_values = 0

    # Iterate through each session, extracting and summing the required totals and number of meter values in each session.
    @sessions.values.each do |session|
      session_json = session.generateJson()
      session_data[:total_charge_amount] += session_json[:charge_amount]
      total_rate_charge += session_json[:total_average_rate_of_charge]
      num_meter_values += session_json[:num_meter_values]
    end

    # Try calculate the average rate of charge. If no meter values present catch it and return zero as the average rate of charge.
    begin
      session_data[:average_rate_of_charge] = (total_rate_charge / num_meter_values)
    rescue
      session_data[:average_rate_of_charge] = 0.00
    end

    return session_data
  end

  # Adds ChargingSession instance to the user.
  # Inputs: ChargingSession session
  # Outputs: Void
  def addSession(session)
    @sessions[session.id] = session
  end

  # Getters and Setters
  attr_accessor :vehicle
  attr_accessor :sessions
  attr_accessor :name

end
