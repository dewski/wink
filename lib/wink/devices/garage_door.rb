module Wink
  module Devices
    class GarageDoor < Device
      def initialize(client, device)
        super

        @device_id = device.fetch("garage_door_id")
      end

      def name
        device["name"]
      end

      def position
        device["last_reading"]["position"]
      end

      def users
        response = client.get('/garage_doors{/garage_door}/users', :garage_door => device_id)
        response.body["data"]
      end

      def subscriptions
        response = client.get('/garage_doors{/garage_door}/subscriptions', :garage_door => device_id)
        response.body["data"]
      end

      def open
        set_position true
      end

      def open?
        position == 1
      end

      def close
        set_position false
      end

      def closed?
        !open?
      end

      def refresh
        response = client.post('/garage_doors{/garage_door}/refresh', :garage_door => device_id)
        response.body["data"]
      end

      def reload
        refresh
        @device = client.garage_door(device_id)
        self
      end

      private

      def set_position(state)
        body = {
          :desired_state => {
            :position => state ? 1 : 0
          }
        }

        response = client.put('/garage_doors{/garage_door}', :garage_door => device_id, :body => body)
        response.success?
      end
    end
  end
end
