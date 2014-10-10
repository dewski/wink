module Wink
  module Config
    attr_accessor :endpoint
    attr_accessor :client_id
    attr_accessor :client_secret
    attr_accessor :access_token
    attr_accessor :refresh_token

    def configure
      yield self
    end

    def reset
      @api_endpoint  = ENV['WINK_ENDPOINT']
      @client_id     = ENV['WINK_CLIENT_ID']
      @client_secret = ENV['WINK_CLIENT_SECRET']
      @access_token  = ENV['WINK_ACCESS_TOKEN']
      @refresh_token = ENV['WINK_REFRESH_TOKEN']
    end

    def endpoint
      @endpoint || 'https://winkapi.quirky.com'
    end

    def client_id
      @client_id || ENV['WINK_CLIENT_ID']
    end

    def client_secret
      @client_secret || ENV['WINK_CLIENT_SECRET']
    end

    def access_token
      @access_token || ENV['WINK_ACCESS_TOKEN']
    end

    def refresh_token
      @refresh_token || ENV['WINK_REFRESH_TOKEN']
    end
  end
end
