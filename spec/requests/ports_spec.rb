require 'rails_helper'

RSpec.describe 'Ports API', type: :request do
  # initialize test data 
  let!(:port_type) { create(:port_type) }
  let!(:ports) { create_list(:port, 10, port_type_id: port_type.id) }
  let(:port_type_id) { port_type.id }
  let(:port_id) { ports.first.id }

  # Test suite for GET /ports
  describe 'GET /ports' do
    # make HTTP get request before each example
    before { get '/ports' }

    it 'returns ports' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

end