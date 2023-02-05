# Author: Harry Brink
# Date: 05/02/2023
# User Class Object to represent an individual charging session of an owners vehicle.

# Reasoning: (I wouldn't usually put a reasoning comment in a file but just so I remember why I did certain things for the future.) Owners can have multiple charging sessions - since owners are the users of the app makes sense to have an owners object which holds all their charging sessions and vehicles for easy access and process during runtime. 

class User

  
  def initialize(name)
    @name = name
    @vehicles = Array.new
    @sessions = {}
  end

  # Generates JSON formatted data for class
  def generateJson()
    return {
      user: @name,
      vehicles: generateVehicleJsons(),
      charging_sessions: generateSessionJsons()
    }
  end

  # Generates an array of owner vehicles in json format.
  def generateVehicleJsons()
    vehicles = Array.new

    @vehicles.each do |vehicle|
      vehicles.push(vehicle.generateJson())
    end

    return vehicles

  end

  # Generates an array of owner sessions in json format.
  def generateSessionJsons()
    json_sessions = Array.new

    sessions.values.each do |session|
      json_sessions.push(session.generateJson())
    end

    return json_sessions
  end

  # Add a vehicle to vehicle list.
  def addVehicle(vehicle)
    @vehicles.push(vehicle)
  end

  def addSession(session)
    puts(session)
    @sessions[session.id] = session
  end

  # Getters and Setters
  def vehicles()
    @vehicles
  end

  def sessions()
    @sessions
  end

  def name()
    @name
  end



end
