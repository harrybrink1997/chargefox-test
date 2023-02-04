# Author: Harry Brink
# Date: 05/02/2023
# Owner Class Object to represent an individual charging session of an owners vehicle.

# Reasoning: (I wouldn't usually put a reasoning comment in a file but just so I remember why I did certain things for the future.) Owners can have multiple charging sessions - since owners are the users of the app makes sense to have an owners object which holds all their charging sessions and vehicles for easy access and process during runtime. 

class Vehicle

  @vehicles = Array.new
  @sessions = Array.new

  def initialize(name)
    @owner = owner
  end

  def generateJson()
    return {
      owner: @owner,
      vehicles: this.generateVehicleJsons(),
      charging_sessions: this.generateSessionJsons()
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
    sessions = Array.new

    @sessions.each do |session|
      sessions.push(session.generateJson())
    end

    return sessions
  end

end
