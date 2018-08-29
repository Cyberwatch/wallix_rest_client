require 'wallix_rest_client/version'
require 'net/http'
require 'net/https'
require 'uri'
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
    attr_accessor :base_uri, :user, :secret, :options

    def initialize
      @base_uri = ''
      @user = ''
      @secret = ''
      @options = {
        auth: :basic,
        verify_ssl: true
      }
    end
  end

  # Wallix API methods
  def self.get_approvals_requests_target(target = nil, query_params = {})
    get 'approvals/requests/target/', target, query_params
  end

  def self.get_targetpasswords_checkout(target = nil, query_params = {})
    get 'targetpasswords/checkout/', target, query_params
  end

  # Common methods
  class << self
    # Build http object with ssl or not
    def build_http(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == 'https')
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE unless configuration.options[:verify_ssl]

      http
    end

    # Build request object with appropriate headers
    def build_request(type, uri)
      request = type.new(uri.request_uri)

      case configuration.options[:auth]
      when :basic
        request.basic_auth(configuration.user, configuration.secret)
      when :apikey
        request['X-Auth-User'] = configuration.user
        request['X-Auth-Key'] = configuration.secret
      end

      request
    end

    # Build query parameters
    def build_query_params(query_params)
      if query_params.empty?
        ''
      else
        '?' + URI.encode_www_form(query_params)
      end
    end

    # Run the HTTP request
    def run_request(path, resource, type, query_params = {}, post_params = {})
      uri = URI.parse([configuration.base_uri, '/api/', path, resource.to_s,
                       build_query_params(query_params)].join(''))

      http = build_http(uri)
      request = build_request(type, uri)

      # Add post data if applicable
      request.set_form_data(post_params) unless post_params.empty?

      http.request(request)
    end

    # Get requests handler
    def get(path, resource, query_params = {})
      run_request(path, resource, Net::HTTP::Get, query_params)
    end

    # Post requests handler
    def post(path, resource, query_params = {}, post_params = {})
      run_request(path, resource, Net::HTTP::Post, query_params, post_params)
    end
  end
end
