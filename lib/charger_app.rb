# Author: Harry Brink
# Date: 05/02/2023
# Charger Application Main File for the Chargingfox Code Test

# Requirements
require 'json'
require_relative 'ChargingSession.rb'
require_relative 'Vehicle.rb'
require_relative 'MeterValue.rb'
require_relative 'User.rb'

class ChargingApp

  # Main fuction for coding test.
  # Inputs: None.
  # Outputs: None.
  def call(meter_json, sessions_json, vehicles_json)

    # Parse the json data files into the application.
    # sessions_file = File.open("../data/charge_sessions.json", "r")
    # meter_file = File.open("../data/meter_values.json", "r")
    # vehicles_file = File.open("../data/vehicles.json", "r")

    # sessions_json = JSON.parse(sessions_file.read)
    # meter_json = JSON.parse(meter_file.read)
    # vehicles_json = JSON.parse(vehicles_file.read)

    users = {}

    # Process and aggregate vehicle and user data.
    vehicles_json.each do |vehicle|
      if (vehicle["user"] != '')
        new_user = User.new(vehicle["user"])
        new_user.addVehicle(Vehicle.new(vehicle["make"], vehicle["model"]))
        users[vehicle["user"]] = new_user
      end
    end

    sessions = {}

    # Process both the session data
    sessions_json.each do |session|
      sessions[session["id"]] = ChargingSession.new(session['id'], session['user'])
    end

    # Process both the meter data
    meter_json.each do |meter|
      sessions[meter["charge_session_id"]].addMeterValue(MeterValue.new(meter["charge_session_id"], meter["amount_of_charge"], meter["rate_of_charge"], meter["timestamp"]))
    end
    
    # Aggregate the session data into the user data.
    sessions.values.each do |session|
      users[session.user].addSession(session)
    end

    users = users.values
    session_data_output = []

    # Pull all session data from each user in json format.
    users.each do |user|
      session_data_output.append(user.generateSessionJsons())
    end

    puts(session_data_output)

    return JSON.generate(session_data_output)

  end