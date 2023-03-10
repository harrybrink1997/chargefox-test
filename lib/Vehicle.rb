# Author: Harry Brink
# Date: 05/02/2023
# Vehicle Class Object to represent an individual charging session of an owners vehicle.

# Reasoning: (I wouldn't usually put a reasoning comment in a file but just so I remember why I did certain things for the future.) Although currently only basic car data. Allows for easier extensibility of specific make and models of cars. E.g. efficiency, etc... 

class Vehicle

  def initialize(make, model)
    @make = make
    @model = model
  end
  
  # Generates JSON formatted data for class
  # Inputs: Void
  # Outputs: Hashmap instance_json_data
  def generateJson()
    return {
      vehicle: @make + ' ' + @model,
      make: @make,
      model: @model
    }
  end

  # Getters and Setters
  attr_accessor :make
  attr_accessor :model

end
