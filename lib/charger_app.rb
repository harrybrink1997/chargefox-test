# Author: Harry Brink
# Date: 05/02/2023
# Charger Application Main File for the Chargingfox Code Test

# Requirements
require 'json'
require_relative 'ChargingSession.rb'
require_relative 'Vehicle.rb'
require_relative 'MeterValue.rb'
require_relative 'User.rb'

class ChargerApp

  # Main fuction for coding test.
  # Inputs: None.
  # Outputs: None.
  def self.call(meter_data, sessions_data, vehicles_data)

    sessions_json = JSON.parse(sessions_data)
    meter_json = JSON.parse(meter_data)
    vehicles_json = JSON.parse(vehicles_data)

    users = {}
    vehicles = {}
    sessions = {}

    # Create all vehicle objects and associated hash map to users.
    vehicles_json.each do |vehicle|
      vehicles[vehicle['user']] = Vehicle.new(vehicle['make'], vehicle['model'])
    end

    # Process both the charging session data and assign the charging sessions to a specific user.
    sessions_json.each do |session|

      if (session['user'] != '' and users[session['user']] == nil)
        new_user = User.new(session['user'], vehicles[session['user']])
        users[session['user']] = new_user
        vehicles.delete(session['user'])
      end

      new_session = ChargingSession.new(session['id'])

      sessions[session['id']] = new_session
      users[session['user']].addSession(new_session)
    end

    # Add in users that do not have any charging sessions.
    vehicles.keys.each do |vehicle_user|
      new_user = User.new(vehicle_user, vehicles[vehicle_user])
      users[vehicle_user] = new_user
    end
    
    # Process both the meter data
    meter_json.each do |meter|
      sessions[meter['charge_session_id']].addMeterValue(MeterValue.new(meter['charge_session_id'], meter['amount_of_charge'], meter['rate_of_charge'], meter['timestamp']))
    end

    # Extract all users and their associated data from hashmap.
    users = users.values
    session_data_output = []

    # Pull all session data from each user in json format.
    users.each do |user|
      session_data_output.append(user.generateJson())
    end

    puts(session_data_output)

    return JSON.generate(session_data_output)

  end
end


def main
  sessions_file = File.open("../data/charge_sessions.json", "r")
  meter_file = File.open("../data/meter_values.json", "r")
  vehicles_file = File.open("../data/vehicles.json", "r")

  sessions_json = sessions_file.read
  meter_json = meter_file.read
  vehicles_json = vehicles_file.read


  ChargerApp.call(meter_json, sessions_json, vehicles_json)
end

main()