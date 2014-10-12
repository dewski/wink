module Wink
  module Devices
    class Device
      attr_reader :client
      attr_reader :device
      attr_reader :device_id

      def initialize(client, device)
        @client = client
        @device = device
      end

      def id
        device_id
      end
    end
  end
end
