module Wink
  class Client
    # Provides access to binary switch API commands.
    #
    # light_bulb_id - The binary switch id as a Integer
    #
    # Returns a BinarySwitch instance.
    def light_bulb(light_bulb_id = nil)
      LightBulb.new self, light_bulb_id
    end

    def light_bulbs
      response = get('/users/me/light_bulbs')
      response.body["data"].collect do |item|
        LightBulb.new(self, item)
      end
    end

    class LightBulb
      def initialize(client, light_bulb_id = nil, attributes = {})
        if light_bulb_id.is_a?(Hash)
          light_bulb_id = light_bulb_id.delete("light_bulb_id")
          attributes = light_bulb_id
        end

        @client        = client
        @light_bulb_id = light_bulb_id
        @name          = attributes.delete("name")
      end

      attr_reader :client, :light_bulb_id, :name

      alias id light_bulb_id

      def users
        response = client.get('/light_bulbs{/light_bulb}/users', :light_bulb => light_bulb_id)
        response.body["data"]
      end

      def subscriptions
        response = client.get('/light_bulbs{/light_bulb}/subscriptions', :light_bulb => light_bulb_id)
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
        light_bulb["last_reading"]["powered"]
      end

      def dim(scale)
        body = {
          :desired_state => {
            :powered => true,
            :brightness => scale
          }
        }

        response = client.put('/light_bulbs{/light_bulb}', :light_bulb => light_bulb_id, :body => body)
        response.success?
      end

      def dimmed?
        brightness = light_bulb["last_reading"]["brightness"]
        brightness > 0 && brightness < 1
      end

      def refresh
        response = client.post('/light_bulbs{/light_bulb}/refresh', :light_bulb => light_bulb_id)
        response.body["data"]
      end

      private

      def light_bulb
        response = client.get('/light_bulbs{/light_bulb}', :light_bulb => light_bulb_id)
        response.body["data"]
      end

      def set_state(state)
        body = {
          :desired_state => {
            :powered => !!state
          }
        }

        response = client.put('/light_bulbs{/light_bulb}', :light_bulb => light_bulb_id, :body => body)
        response.success?
      end
    end
  end
end
