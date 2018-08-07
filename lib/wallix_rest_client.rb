require 'wallix_rest_client/version'
require 'rest-client'
require 'openssl'
require 'addressable/uri'
require 'deep_symbolize'
require 'json'

# Gem to use the Wallix Admin Bastion REST API
module WallixRestClient
  class << self
    attr_accessor :configuration
  end

  def self.setup
    @configuration ||= Configuration.new
    yield(configuration)
  end

  # Handle the Wallix REST API Settings
  class Configuration
    attr_accessor :host, :mode, :user, :secret, :verify_ssl

    def initialize
      @host = ''
      @mode = nil
      @user = ''
      @secret = ''
      @verify_ssl = true
    end
  end

  # Wallix API methods
  def self.get_approvals_requests_target(target = nil, params = {})
    get 'approvals/requests/target', target, params
  end

  def self.get_targetpasswords_checkout(target = nil, params = {})
    get 'targetpasswords/checkout', target, params
  end

  # Common methods
  class << self
    # Authentication and common headers handler
    def resource
      case configuration.mode
      when :basic
        RestClient::Resource.new(configuration.host,
                                 user: configuration.user,
                                 password: configuration.secret,
                                 verify_ssl: configuration.verify_ssl)
      when :apikey
        RestClient::Resource.new(configuration.host,
                                 headers: {
                                   x_auth_user: configuration.user,
                                   x_auth_key: configuration.secret
                                 },
                                 verify_ssl: configuration.verify_ssl)
      else
        raise 'Bad configuration mode value. Please set it to :basic or :apikey.'
      end
    end

    # Get requests handler
    def get(api_group, action, params = {})
      res = resource[api_group + '/' + action.to_s].get params: params.compact
      res_hash res
    end

    def res_hash(res)
      data = JSON.parse(res.body)
      data.extend DeepSymbolizable
      { data: data.deep_symbolize, res: res }
    end
  end
end
