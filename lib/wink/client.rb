require "faraday"
require "faraday_middleware"
require "multi_json"
require "addressable/template"

module Wink
  class Client
    def connection
      @connection ||= Faraday.new(Wink.endpoint) do |conn|
        conn.options[:timeout]      = 5
        conn.options[:open_timeout] = 2

        conn.request  :json
        conn.response :json, :content_type => /\bjson$/

        # Authorization: Bearer 4b91e37b5742a8702204bc4829c46257
        conn.authorization :bearer, Wink.access_token

        conn.adapter Faraday.default_adapter # make requests with Net::HTTP
      end
    end

    def request(method, path, params = {})
      body = params.delete(:body)
      body = MultiJson.dump(body) if Hash === body

      path = expand_path(path, params)

      case method
      when :post
        connection.post(path) do |req|
          req.body = body if body
        end
      when :get
        connection.get(path) do |req|
          req.body = body if body
        end
      when :put
        connection.put(path, body)
      end
    end

    def post(path, params = {})
      request(:post, path, params)
    end

    def get(path, params = {})
      request(:get, path, params)
    end

    def put(path, params = {})
      request(:put, path, params)
    end

    def expand_path(path, params)
      template = Addressable::Template.new path

      expansions = {}
      query_values = params.dup

      template.keys.map(&:to_sym).each do |key|
        value = query_values.delete key
        expansions[key] = value
      end

      uri = template.expand(expansions)
      uri.query_values = query_values unless query_values.empty?
      uri.to_s
    end
  end
end

