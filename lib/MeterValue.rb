# Author: Harry Brink
# Date: 05/02/2023
# Charging Session Class Object to represent an individual charging session of an owners vehicle.

# Reasoning: (I wouldn't usually put a reasoning comment in a file but just so I remember why I did certain things for the future.) It's a core object in the application.

class MeterValue

  def initialize(charge_session_id, amount_of_charge, rate_of_charge, timestamp)
    @charge_session_id = charge_session_id
    @amount_of_charge = amount_of_charge
    @rate_of_charge = rate_of_charge
    @timestamp = timestamp
  end
  
  def generateJson()
    return {
      charge_session_id: @charge_session_id,
      amount_of_charge: @amount_of_charge,
      rate_of_charge: @rate_of_charge,
      timestamp: @timestamp  
    }
  end

end
