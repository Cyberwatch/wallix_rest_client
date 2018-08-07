RSpec.describe WallixRestClient do
  it 'has a version number' do
    expect(WallixRestClient::VERSION).not_to be nil
  end

  context 'WALLIX API CALLS - AUTH' do
    xit 'can authenticate with :apikey mode' do
      # Mockup Bittrex account for Rspec
      WallixRestClient.setup do |config|
        config.host = 'http://127.0.0.1/api'
        config.mode = :apikey
        config.user = 'login'
        config.secret = 'apikey'
      end

      # TODO
    end

    xit 'can authenticate with :basic mode' do
      # Mockup Bittrex account for Rspec
      WallixRestClient.setup do |config|
        config.host = 'http://127.0.0.1/api'
        config.mode = :basic
        config.user = 'login'
        config.secret = 'password'
      end

      # TODO
    end
  end
end
