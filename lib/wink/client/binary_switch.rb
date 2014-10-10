module Wink
  class Client
    # Provides access to binary switch API commands.
    #
    # binary_switch_id - The binary switch id as a Integer
    #
    # Returns a BinarySwitch instance.
    def binary_switch(binary_switch_id = nil)
      BinarySwitch.new self, binary_switch_id
    end

    class BinarySwitch
      def initialize(client, binary_switch_id = nil)
        @client           = client
        @binary_switch_id = binary_switch_id
      end

      attr_reader :client, :binary_switch_id

      def users
        response = client.get('/binary_switches{/binary_switch}/users', :binary_switch => binary_switch_id)
        response.body["data"]
      end

      def subscriptions
        response = client.get('/binary_switches{/binary_switch}/subscriptions', :binary_switch => binary_switch_id)
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
        binary_switch["desired_state"]["powered"]
      end

      def refresh
        response = client.post('/binary_switches{/binary_switch}/refresh', :binary_switch => binary_switch_id)
        response.success?
      end

      private

      def binary_switch
        response = client.get('/binary_switches{/binary_switch}', :binary_switch => binary_switch_id)
        response.body["data"]
      end

      def set_state(state)
        body = {
          :desired_state => {
            :powered => !!state
          }
        }

        response = client.put('/binary_switches{/binary_switch}', :binary_switch => binary_switch_id, :body => body)
        response.success?
      end
    end
  end
end
