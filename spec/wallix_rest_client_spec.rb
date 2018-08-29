require 'base64'

RSpec.describe WallixRestClient do
  it 'has a version number' do
    expect(WallixRestClient::VERSION).not_to be nil
  end

  describe 'WALLIX API CALLS - AUTH' do
    context 'can authenticate with :apikey mode' do
      before(:all) do
        WallixRestClient.setup do |config|
          config.base_uri = 'http://127.0.0.1'
          config.user = 'login'
          config.secret = 'apikey'
          config.options = {
              auth: :apikey
          }
        end
      end

      let(:config) { config = WallixRestClient.configuration }
      let(:uri) { uri = URI.parse([WallixRestClient.configuration.base_uri, '/api/'].join('')) }
      let(:request) { request = WallixRestClient.build_request(Net::HTTP::Get, uri) }

      it 'sets correctly the auth headers' do
        expect(request['X-Auth-User']).to eq(config.user)
        expect(request['X-Auth-Key']).to eq(config.secret)
      end
    end

    context 'can authenticate with :basic mode' do
      before(:all) do
        WallixRestClient.setup do |config|
          config.base_uri = 'http://127.0.0.1/api'
          config.user = 'login'
          config.secret = 'password'
          config.options = {
              auth: :basic
          }
        end
      end

      let(:config) { config = WallixRestClient.configuration }
      let(:uri) { uri = URI.parse([WallixRestClient.configuration.base_uri, '/api/'].join('')) }
      let(:request) { request = WallixRestClient.build_request(Net::HTTP::Get, uri) }

      it 'sets correctly the auth headers' do
        expect(request['Authorization']).to eq('Basic ' + Base64.encode64(config.user + ':' + config.secret).strip)
      end
    end
  end
end
