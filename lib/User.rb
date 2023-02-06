# Author: Harry Brink
# Date: 05/02/2023
# User Class Object to represent an individual charging session of an owners vehicle.

# Reasoning: (I wouldn't usually put a reasoning comment in a file but just so I remember why I did certain things for the future.) Owners can have multiple charging sessions - since owners are the users of the app makes sense to have an owners object which holds all their charging sessions and vehicles for easy access and process during runtime. 

class User

  
  def initialize(name, vehicle)
    @name = name
    @vehicle = vehicle
    @sessions = {}
  end

  # Generates JSON formatted data for class
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

  # Generates an array of owner sessions in json format.
  def generateSessionData()

    session_data = {
      total_charge_amount: 0,
      average_rate_of_charge: 0
    }

    total_rate_charge = 0
    num_meter_values = 0


    @sessions.values.each do |session|
      session_json = session.generateJson()
      session_data[:total_charge_amount] += session_json[:charge_amount]
      total_rate_charge += session_json[:total_average_rate_of_charge]
      num_meter_values += session_json[:num_meter_values]
    end

    begin
      session_data[:average_rate_of_charge] = (total_rate_charge / num_meter_values)
    rescue
      session_data[:average_rate_of_charge] = 0.00
    end

    return session_data
  end

  def addSession(session)
    @sessions[session.id] = session
  end

  # Getters and Setters
  def vehicle()
    @vehicle
  end

  def sessions()
    @sessions
  end

  def name()
    @name
  end



end
