# Author: Harry Brink
# Date: 05/02/2023
# Charger Application Main File for the Chargingfox Code Test

# Requirements
require 'json'
require_relative 'ChargingSession.rb'
require_relative 'Vehicle.rb'
require_relative 'MeterValue.rb'

#Inclusions

# Main fuction for coding test.
# Inputs: None.
# Outputs: None.
def main

  # Parse the json data files into the application.
  sessions_file = File.open("../data/charge_sessions.json", "r")
  meter_file = File.open("../data/meter_values.json", "r")
  vehicles_file = File.open("../data/vehicles.json", "r")

  sessions_json = JSON.parse(sessions_file.read)
  meter_json = JSON.parse(meter_file.read)
  vehicles_json = JSON.parse(vehicles_file.read)

  sessions_map = {}

  sessions_json.each do |session|
    sessions_map[session['id']] = ChargingSession.new(session['id'], session['user'])
  end

  

  puts(sessions_map)



end

main()