module Wink
  module Devices
    class BinarySwitch < Device
      def initialize(client, device)
        super

        @device_id = device.fetch("binary_switch_id")
        @name      = device["name"]
        @powered   = device["last_reading"]["powered"]
      end

      attr_reader :name, :powered

      def users
        response = client.get('/binary_switches{/binary_switch}/users', :binary_switch => device_id)
        response.body["data"]
      end

      def subscriptions
        response = client.get('/binary_switches{/binary_switch}/subscriptions', :binary_switch => device_id)
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

      def refresh
        response = client.post('/binary_switches{/binary_switch}/refresh', :binary_switch => device_id)
        response.body["data"]
      end

      private

      def set_state(state)
        body = {
          :desired_state => {
            :powered => !!state
          }
        }

        response = client.put('/binary_switches{/binary_switch}', :binary_switch => device_id, :body => body)
        response.success?
      end
    end
  end
end
