require "wink/devices/device"

module Wink
  module Devices
    class LightBulb < Device
      def initialize(client, device)
        super

        @device_id  = device.fetch("light_bulb_id")
      end

      def name
        device["name"]
      end

      def powered
        device["last_reading"]["powered"]
      end

      def brightness
        device["last_reading"]["brightness"]
      end

      def users
        response = client.get('/light_bulbs{/light_bulb}/users', :light_bulb => device_id)
        response.body["data"]
      end

      def subscriptions
        response = client.get('/light_bulbs{/light_bulb}/subscriptions', :light_bulb => device_id)
        response.body["data"]
      end

      def on
        set_state true
      end

      def on?
        powered?
      end

      def off
        set_state false
      end

      def off?
        !powered?
      end

      def powered?
        !!powered
      end

      def dim(scale)
        body = {
          :desired_state => {
            :powered => true,
            :brightness => scale
          }
        }

        response = client.put('/light_bulbs{/light_bulb}', :light_bulb => device_id, :body => body)
        response.success?
      end

      def dimmed?
        brightness > 0 && brightness < 1
      end

      def refresh
        response = client.post('/light_bulbs{/light_bulb}/refresh', :light_bulb => device_id)
        response.body["data"]
      end

      def reload
        refresh
        response = client.get('/light_bulbs{/light_bulb}', :light_bulb => device_id)
        @device = response.body["data"]
        self
      end

      private

      def set_state(state)
        body = {
          :desired_state => {
            :powered => !!state
          }
        }

        response = client.put('/light_bulbs{/light_bulb}', :light_bulb => device_id, :body => body)
        response.success?
      end
    end
  end
end
