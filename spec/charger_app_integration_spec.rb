require_relative './spec_helper'
require_relative '../lib/charger_app.rb'

RSpec.describe 'integration' do
  let(:meter_values) do
    <<-JSON
      [
        { "charge_session_id": "8", "amount_of_charge": "0", "rate_of_charge": "0", "timestamp": "2022-08-18 02:10:15" },
        { "charge_session_id": "8", "amount_of_charge": "0", "rate_of_charge": "0", "timestamp": "2022-08-18 02:10:10" },
        { "charge_session_id": "8", "amount_of_charge": "0", "rate_of_charge": "0", "timestamp": "2022-08-18 02:10:05" },
        { "charge_session_id": "7", "amount_of_charge": "3100", "rate_of_charge": "1232", "timestamp": "2022-08-18 01:59:56" },
        { "charge_session_id": "7", "amount_of_charge": "3010", "rate_of_charge": "987", "timestamp": "2022-08-18 01:59:56" },
        { "charge_session_id": "7", "amount_of_charge": "2988", "rate_of_charge": "657", "timestamp": "2022-08-18 01:59:56" },
        { "charge_session_id": "6", "amount_of_charge": "1650", "rate_of_charge": "987", "timestamp": "2022-08-18 10:10:20" },
        { "charge_session_id": "6", "amount_of_charge": "1500", "rate_of_charge": "1342", "timestamp": "2022-08-18 10:10:15" },
        { "charge_session_id": "6", "amount_of_charge": "1234", "rate_of_charge": "4563", "timestamp": "2022-08-18 10:10:10" },
        { "charge_session_id": "5", "amount_of_charge": "1350", "rate_of_charge": "0", "timestamp": "2022-08-18 03:01:25" },
        { "charge_session_id": "5", "amount_of_charge": "1300", "rate_of_charge": "1111", "timestamp": "2022-08-18 03:01:15" },
        { "charge_session_id": "5", "amount_of_charge": "1270", "rate_of_charge": "1231", "timestamp": "2022-08-18 02:59:56" },
        { "charge_session_id": "5", "amount_of_charge": "1240", "rate_of_charge": "3214", "timestamp": "2022-08-18 02:59:46" },
        { "charge_session_id": "5", "amount_of_charge": "1000", "rate_of_charge": "1300", "timestamp": "2022-08-18 02:59:36" },
        { "charge_session_id": "4", "amount_of_charge": "2988", "rate_of_charge": "3300", "timestamp": "2022-08-18 01:59:56" },
        { "charge_session_id": "4", "amount_of_charge": "2554", "rate_of_charge": "4300", "timestamp": "2022-08-18 01:57:21" },
        { "charge_session_id": "4", "amount_of_charge": "1258", "rate_of_charge": "2000", "timestamp": "2022-08-18 01:55:51" },
        { "charge_session_id": "4", "amount_of_charge": "456", "rate_of_charge": "1000", "timestamp": "2022-08-18 01:53:51" },
        { "charge_session_id": "3", "amount_of_charge": "287", "rate_of_charge": "5660", "timestamp": "2022-08-18 02:07:59" },
        { "charge_session_id": "3", "amount_of_charge": "195", "rate_of_charge": "5930", "timestamp": "2022-08-18 02:06:43" },
        { "charge_session_id": "3", "amount_of_charge": "103", "rate_of_charge": "6310", "timestamp": "2022-08-18 02:05:11" },
        { "charge_session_id": "3", "amount_of_charge": "17", "rate_of_charge": "5711", "timestamp": "2022-08-18 02:03:06" },
        { "charge_session_id": "2", "amount_of_charge": "1287", "rate_of_charge": "600", "timestamp": "2022-08-18 04:35:45" },
        { "charge_session_id": "2", "amount_of_charge": "1054", "rate_of_charge": "300", "timestamp": "2022-08-18 04:31:15" },
        { "charge_session_id": "2", "amount_of_charge": "523", "rate_of_charge": "200", "timestamp": "2022-08-18 04:29:17" },
        { "charge_session_id": "2", "amount_of_charge": "50", "rate_of_charge": "100", "timestamp": "2022-08-18 04:26:43" },
        { "charge_session_id": "1", "amount_of_charge": "3187", "rate_of_charge": "4700", "timestamp": "2022-08-18 04:41:05" },
        { "charge_session_id": "1", "amount_of_charge": "2195", "rate_of_charge": "3600", "timestamp": "2022-08-18 04:36:36" },
        { "charge_session_id": "1", "amount_of_charge": "903", "rate_of_charge": "2600", "timestamp": "2022-08-18 04:33:31" },
        { "charge_session_id": "1", "amount_of_charge": "130", "rate_of_charge": "1300", "timestamp": "2022-08-18 04:31:57" }
      ]
    JSON
  end

  let(:charge_sessions) do
    <<-JSON
      [
        { "id": "1", "user": "Gordon Cote" },
        { "id": "2", "user": "Lorna Phillips" },
        { "id": "3", "user": "Lorna Phillips" },
        { "id": "4", "user": "Esmai Merritt" },
        { "id": "5", "user": "Harvey Norman" },
        { "id": "6", "user": "Harvey Norman" },
        { "id": "7", "user": "Harvey Norman" },
        { "id": "8", "user": "Harvey Norman" }
      ]
    JSON
  end

  let(:vehicles) do
    <<-JSON
      [
        { "user": "Lorna Phillips", "make": "Tesla", "model": "Model 3" },
        { "user": "Esmai Merritt", "make": "Tesla", "model": "Model 3 Long Range" },
        { "user": "Gordon Cote", "make": "BMW", "model": "iX M60" },
        { "user": "Fred Smith", "make": "Tesla", "model": "Model X" },
        { "user": "Harvey Norman", "make": "Tesla", "model": "Semi" }
      ]
    JSON
  end

  let(:expected_result_json) do
    <<-JSON
      [
        { "user": "Gordon Cote", "vehicle": "BMW iX M60", "session_count": "1", "total_charge_amount": "3.19 kWh", "average_rate_of_charge": "3.05 kW" },
        { "user": "Lorna Phillips", "vehicle": "Tesla Model 3", "session_count": "2", "total_charge_amount": "1.57 kWh", "average_rate_of_charge": "3.10 kW"},
        { "user": "Esmai Merritt", "vehicle": "Tesla Model 3 Long Range", "session_count": "1", "total_charge_amount": "2.99 kWh", "average_rate_of_charge": "2.65 kW"},
        { "user": "Harvey Norman", "vehicle": "Tesla Semi", "session_count": "4", "total_charge_amount": "6.10 kWh", "average_rate_of_charge": "1.19 kW"},
        { "user": "Fred Smith", "vehicle": "Tesla Model X", "session_count": "0", "total_charge_amount": "0.00 kWh", "average_rate_of_charge": "0.00 kW"}
      ]
    JSON
  end

  describe Vehicle do
    subject(:result) do
      vehicle = Vehicle.new('BMW', 'iX M60')
    end

    it 'creates a instance as expected' do
      expect(result.make()).to eq('BMW')
      expect(result.model()).to eq('iX M60')
    end
    
    it 'outputs json format as expected' do
      json = result.generateJson()
      expect(json[:model]).to eq('iX M60')
      expect(json[:make]).to eq('BMW')
      expect(json[:vehicle]).to eq('BMW iX M60')
    end
  end

  describe MeterValue do
    subject(:result) do
      meter_value = MeterValue.new("404", "14", "2300", "2022-08-18 04:43:17")
    end

    it 'creates a instance as expected' do
      expect(result.charge_session_id()).to eq('404')
      expect(result.amount_of_charge()).to eq(14)
      expect(result.rate_of_charge()).to eq(2300)
      expect(result.timestamp()).to eq("2022-08-18 04:43:17")
    end
    
    it 'outputs json format as expected' do
      json = result.generateJson()
      expect(json[:charge_session_id]).to eq('404')
      expect(json[:amount_of_charge]).to eq(14)
      expect(json[:rate_of_charge]).to eq(2300)
      expect(json[:timestamp]).to eq("2022-08-18 04:43:17")
    end
  end

  describe ChargingSession do
    subject(:result) do
      meter_value_1 = MeterValue.new("404", "14", "2300", "2022-08-18 04:43:17")
      meter_value_2 = MeterValue.new("404", "20", "1400", "2022-08-18 04:43:18")
      meter_value_3 = MeterValue.new("404", "30", "2300", "2022-08-18 04:43:23")

      session = ChargingSession.new("404")
      session.addMeterValue(meter_value_1)
      session.addMeterValue(meter_value_2)
      session.addMeterValue(meter_value_3)

      return session

    end

    it 'creates a instance as expected' do
      expect(result.id()).to eq('404')
      expect(result.num_meter_values()).to eq(3)
      expect(result.meter_values()[0].timestamp()).to eq("2022-08-18 04:43:17")
      expect(result.meter_values()[1].timestamp()).to eq("2022-08-18 04:43:18")
      expect(result.meter_values()[2].timestamp()).to eq("2022-08-18 04:43:23")
    end
    
    it 'outputs json format as expected' do
      json = result.generateJson()
      expect(json[:id]).to eq('404')
      expect(json[:charge_amount]).to eq(0.03)
      expect(json[:total_average_rate_of_charge]).to eq(6)
      expect(json[:num_meter_values]).to eq(3)
    end
  end

  describe User do
    subject(:result) do
      vehicle = Vehicle.new('BMW', 'iX M60')
      user = User.new('Gordon Cote', vehicle)

    end

    it 'creates a instance as expected' do
      expect(result.vehicle().make()).to eq('BMW')
      expect(result.vehicle().model()).to eq('iX M60')
      expect(result.sessions()).to eq({})
      expect(result.name()).to eq('Gordon Cote')
    end
    
    it 'adds session as expected ' do
      meter_value_1 = MeterValue.new("404", "14", "2300", "2022-08-18 04:43:17")
      meter_value_2 = MeterValue.new("404", "20", "1400", "2022-08-18 04:43:18")
      meter_value_3 = MeterValue.new("404", "30", "2300", "2022-08-18 04:43:23")

      session = ChargingSession.new("404")
      session.addMeterValue(meter_value_1)
      session.addMeterValue(meter_value_2)
      session.addMeterValue(meter_value_3)

      result.addSession(session)

      expect(result.sessions().keys.length).to eq(1)

    end
    
    it 'outputs instance json format as expected' do
      meter_value_1 = MeterValue.new("404", "14", "2300", "2022-08-18 04:43:17")
      meter_value_2 = MeterValue.new("404", "20", "1400", "2022-08-18 04:43:18")
      meter_value_3 = MeterValue.new("404", "30", "2300", "2022-08-18 04:43:23")

      session = ChargingSession.new("404")
      session.addMeterValue(meter_value_1)
      session.addMeterValue(meter_value_2)
      session.addMeterValue(meter_value_3)

      result.addSession(session)

      json = result.generateJson()
      expect(json[:total_charge_amount]).to eq('0.03 kWh')
      expect(json[:average_rate_of_charge]).to eq('2.00 kW')
      expect(json[:vehicle]).to eq('BMW iX M60')
      expect(json[:user]).to eq('Gordon Cote')
      expect(json[:session_count]).to eq('1')
    end
  end

  describe ChargerApp do
    subject(:result) do
      json_result = ChargerApp.call(meter_values, charge_sessions, vehicles)
      JSON.parse(json_result)
    end

    it 'outputs JSON in expected form' do
      expect(result).to eq JSON.parse(expected_result_json)
    end

    it 'has users who charged' do
      expect(result[0]['user']).to eq('Gordon Cote')
      expect(result[1]['user']).to eq('Lorna Phillips')
      expect(result[2]['user']).to eq('Esmai Merritt')
    end

    it 'has session count for each user' do
      expect(result[0]['session_count']).to eq('1')
      expect(result[1]['session_count']).to eq('2')
      expect(result[2]['session_count']).to eq('1')
      expect(result[3]['session_count']).to eq('4')
    end

    it 'has session count for each user' do
      expect(result[0]['vehicle']).to eq('BMW iX M60')
      expect(result[1]['vehicle']).to eq('Tesla Model 3')
      expect(result[2]['vehicle']).to eq('Tesla Model 3 Long Range')
      expect(result[3]['vehicle']).to eq('Tesla Semi')
    end
    
    it 'has kilowatt_total for each user' do
      expect(result[0]['total_charge_amount']).to eq('3.19 kWh')
      expect(result[1]['total_charge_amount']).to eq('1.57 kWh')
      expect(result[2]['total_charge_amount']).to eq('2.99 kWh')
      expect(result[3]['total_charge_amount']).to eq('6.10 kWh')
    end
    
    it 'has average charge speed for each user' do
      expect(result[0]['average_rate_of_charge']).to eq('3.05 kW')
      expect(result[1]['average_rate_of_charge']).to eq('3.10 kW')
      expect(result[2]['average_rate_of_charge']).to eq('2.65 kW')
      expect(result[3]['average_rate_of_charge']).to eq('1.19 kW')
    end
    
    it 'has correct average charge speed for a user without charging sessions' do
      expect(result[4]['average_rate_of_charge']).to eq('0.00 kW')
    end
    it 'has correct kilowatt_total for a user without charging sessions' do
      expect(result[4]['total_charge_amount']).to eq('0.00 kWh')
    end
  end
end
