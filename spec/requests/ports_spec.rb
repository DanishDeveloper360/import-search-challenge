require 'rails_helper'

RSpec.describe 'Ports API', type: :request do
  # initialize test data 
  let(:user) { create(:user) }
  let!(:port_type) { create(:port_type) }
  let!(:ports) { create_list(:port, 10, port_type_id: port_type.id) }
  let(:port_type_id) { port_type.id }
  let(:port_id) { ports.first.id }
  let(:port_code) { ports.first.code }
  let(:port_name) { ports.first.name }
  # authorize request
  let(:headers) { valid_headers }

  # Test suite for GET /ports
  describe 'GET /ports' do
    # make HTTP get request before each example
    before { get '/ports', params: {}, headers: headers }

    it 'returns ports' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /ports/search?code=port_code
  describe 'GET /ports/search code' do
    # make HTTP get request before each example
    before { get "/ports/search?code=#{port_code}", params: {}, headers: headers }

    context 'when port exists' do
        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
  
        it 'returns the port' do
          expect(json['code']).to eq(port_code)
        end
    end
  
    context 'when port does not exist' do
        let(:port_code) { 'NOT-E' }
  
        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end
  
        it 'returns a not found message' do
          expect(json['message']).to match(/Sorry, Port not found./)
        end
    end
  end

    # Test suite for GET /ports/search?name=port_name
  describe 'GET /ports/search name' do
        # make HTTP get request before each example
        before { get "/ports/search?name=#{port_name}", params: {}, headers: headers }
    
        context 'when port exists' do
            it 'returns status code 200' do
              expect(response).to have_http_status(200)
            end
      
            it 'returns the port array' do
              expect(json.count).to be > 0
            end

            it 'returns the port array' do
              expect(json[0]['name']).to include(port_name)
            end
        end
      
        context 'when port does not exist' do
            let(:port_name) { 'no value' }
      
            it 'returns status code 404' do
              expect(response).to have_http_status(404)
            end
      
            it 'returns a not found message' do
              expect(json['message']).to match(/Sorry, Port not found./)
            end
        end
  end

  
    # Test suite for GET /ports/search_partial_text?text=search_string_as_desired
  describe 'GET /ports/search_partial_text' do
      # make HTTP get request before each example
      before { get "/ports/search_partial_text?text=#{port_name.slice(0..2)}", params: {}, headers: headers }
  
      context 'when port exists' do
          it 'returns status code 200' do
            expect(response).to have_http_status(200)
          end
    
          it 'returns the port array' do
            expect(json.count).to be > 0
          end

          it 'returns the port array' do
            expect(json[0]['name']).to include(port_name)
          end

          it 'returns the port array' do
            match_string = port_name.slice(0..2)
            is_mis_match = json.any? { |item| !(item['name'].include? match_string) && !(item['code'].include? match_string) && !(item['city'].include? match_string) && !(item['oceans_insights_code'].include? match_string) }

            expect(is_mis_match).to be false
          end

      end
    
      context 'when port does not exist' do
          let(:port_name) { 'zzzzzzzzzzzzzzzzzz' }
    
          it 'returns status code 404' do
            expect(response).to have_http_status(404)
          end
    
          it 'returns a not found message' do
            expect(json['message']).to match(/Sorry, Port not found./)
          end
      end
  end


      # Test suite for GET /ports/search_full_text?text=search_string_as_desired
  describe 'GET /ports/search_full_text' do
        # make HTTP get request before each example
        before { get "/ports/search_full_text?text=#{port_name.slice(0..2)}", params: {}, headers: headers }
    
        context 'when port exists' do
            it 'returns status code 200' do
              expect(response).to have_http_status(200)
            end
      
            it 'returns the port array' do
              expect(json.count).to be > 0
            end
  
            it 'returns the port array' do
              match_string = port_name.slice(0..2)
              expect(json[0]['name']).to include(match_string)
            end

        end
      
        context 'when port does not exist' do
            let(:port_name) { 'zzzzzzzzzzzzzzzzzz' }
      
            it 'returns status code 404' do
              expect(response).to have_http_status(404)
            end
      
        end
  end

end