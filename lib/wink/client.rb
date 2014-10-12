require "faraday"
require "faraday_middleware"
require "multi_json"
require "addressable/template"

module Wink
  class Client
    def devices
      response = get('/users/me/wink_devices')
      response.body["data"].collect do |device|
        if device.key?("garage_door_id")
          garage_door(device)
        elsif device.key?("light_bulb_id")
          light_bulb(device)
        elsif device.key?("binary_switch_id")
          binary_switch(device)
        end
      end
    end

    # Public: Lookup an individual light bulb device from your Wink Hub.
    #
    # light_bulb - The Hash data of the device or device id to lookup.
    #
    # Returns Wink::Devices::LightBulb instance.
    def light_bulb(device)
      unless device.is_a?(Hash)
        response = get('/light_bulbs{/light_bulb}', :light_bulb => device)
        device   = response.body["data"]
      end

      Devices::LightBulb.new(self, device)
    end

    # Public: Lookup all connected light bulbs to your Wink Hub.
    #
    # Returns Array of Wink::Devices::LightBulb instances.
    def light_bulbs
      response = get('/users/me/light_bulbs')
      response.body["data"].collect do |device|
        Devices::LightBulb.new(self, device)
      end
    end

    # Public: Lookup an individual binary switch connected to your Wink Hub.
    #
    # device - The Hash data of the device or device id to lookup.
    #
    # Returns Wink::Devices::BinarySwitch instance.
    def binary_switch(device)
      unless device.is_a?(Hash)
        response = get('/binary_switches{/binary_switch}', :binary_switch => device)
        device   = response.body["data"]
      end

      Devices::BinarySwitch.new(self, device)
    end

    # Public: Lookup all binary switches connected to your Wink Hub.
    #
    # Returns Array of Wink::Devices::BinarySwitch instances.
    def binary_switches
      response = get('/users/me/binary_switches')
      response.body["data"].collect do |device|
        Devices::BinarySwitch.new(self, device)
      end
    end

    # Public: Lookup an individual garage door connected to your Wink Hub.
    #
    # device - The Hash data of the device or device id to lookup.
    #
    # Returns Wink::Devices::GarageDoor instance.
    def garage_door(device)
      unless device.is_a?(Hash)
        response = get('/garage_doors{/garage_door}', :garage_door => device)
        device   = response.body["data"]
      end

      Devices::GarageDoor.new(self, device)
    end

    # Public: Lookup all connected garage doors to your Wink Hub.
    #
    # Returns Array of Wink::Devices::GarageDoor instances.
    def garage_doors
      response = get('/users/me/garage_doors')
      response.body["data"].collect do |device|
        Devices::GarageDoor.new(self, device)
      end
    end

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
