require 'spec_helper'
require 'charger_app'

# TODO: - Add more timestamps
RSpec.describe 'integration' do
  let(:meter_values) do
    <<-JSON
      [
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
        { "id": "4", "user": "Esmai Merritt" }
      ]
    JSON
  end

  let(:vehicles) do
    <<-JSON
      [
        { "user": "Lorna Phillips", "make": "Tesla", "model": "Model 3" },
        { "user": "Esmai Merritt", "make": "Tesla", "model": "Model 3 Long Range" },
        { "user": "Gordon Cote", "make": "BMW", "model": "iX M60" }
      ]
    JSON
  end

  let(:expected_result_json) do
    <<-JSON
      [
        { "user": "Gordon Cote", "vehicle": "BMW iX M60", "session_count": "1", "total_charge_amount": "3.19 kWh", "average_rate_of_charge": "3.05 kW" },
        { "user": "Lorna Phillips", "vehicle": "Tesla Model 3", "session_count": "2", "total_charge_amount": "1.57 kWh", "average_rate_of_charge": "3.10 kW"},
        { "user": "Esmai Merritt", "vehicle": "Tesla Model 3 Long Range", "session_count": "1", "total_charge_amount": "2.99 kWh", "average_rate_of_charge": "2.65 kW"}
      ]
    JSON
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
    end

    it 'has session count for each user' do
      expect(result[0]['vehicle']).to eq('BMW iX M60')
      expect(result[1]['vehicle']).to eq('Tesla Model 3')
      expect(result[2]['vehicle']).to eq('Tesla Model 3 Long Range')
    end

    it 'has kilowatt_total for each user' do
      expect(result[0]['total_charge_amount']).to eq('3.19 kWh')
      expect(result[1]['total_charge_amount']).to eq('1.57 kWh')
      expect(result[2]['total_charge_amount']).to eq('2.99 kWh')
    end

    it 'has average charge speed for each user' do
      expect(result[0]['average_rate_of_charge']).to eq('3.05 kW')
      expect(result[1]['average_rate_of_charge']).to eq('3.10 kW')
      expect(result[2]['average_rate_of_charge']).to eq('2.65 kW')
    end
  end
end
