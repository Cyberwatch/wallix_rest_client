require 'base64'

RSpec.describe WallixRestClient do
  it 'has a version number' do
    expect(WallixRestClient::VERSION).not_to be nil
  end

  describe 'WALLIXRESTCLIENT METHODS' do

    let(:config) { config = WallixRestClient.configuration }
    let(:uri) { uri = URI.parse([WallixRestClient.configuration.base_uri, '/api/'].join('')) }
    let(:request) { request = WallixRestClient.build_request(Net::HTTP::Get, uri) }

    context 'can build_http' do
      it 'can verify SSL certificate' do
        WallixRestClient.setup do |config|
          config.options = {
              verify_ssl: true
          }
        end

        expect(WallixRestClient.build_http(URI.parse('https://localhost/')).verify_mode).to be_nil
      end

      it 'can ignore SSL certificate' do
        WallixRestClient.setup do |config|
          config.options = {
              verify_ssl: false
          }
        end

        expect(WallixRestClient.build_http(URI.parse('https://localhost/')).verify_mode).to eq(OpenSSL::SSL::VERIFY_NONE)
      end
    end

    context 'can build_query_params' do
      it 'can build with empty query params' do
        expect(WallixRestClient.build_query_params({})).to eq('')
      end

      it 'can build with valid query params' do
        expect(WallixRestClient.build_query_params({ param1: 'value1', param2: 'value2' })).to eq('?param1=value1&param2=value2')
      end
    end
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

  describe 'WALLIX API CALLS - RUN' do
    before(:all) do
      WallixRestClient.setup do |config|
        config.base_uri = 'https://www.example.com'
        config.user = 'login'
        config.secret = 'password'
        config.options = {
            auth: :basic
        }
      end
    end

    context 'can run requests' do
      it 'run_request' do
        expect(WallixRestClient.run_request('', '', Net::HTTP::Get, {}).code).to eq('404')
      end

      it 'get' do
        expect(WallixRestClient.get('', '', {}).code).to eq('404')
      end

      it 'post' do
        expect(WallixRestClient.post('', '', {}, {}).code).to eq('404')
      end
    end
  end

  describe 'WALLIX API CALLS - VALIDATE API' do
    xit 'get_approvals_requests_target' do
      #TODO
    end

    xit 'get_targetpasswords_checkout' do
      #TODO
    end
  end
end
