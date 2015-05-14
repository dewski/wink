module Wink
  class Group
    attr_reader :client
    attr_reader :group
    attr_reader :group_id

    def initialize(client, group)
      @client = client
      @group = group

      @group_id  = group.fetch("group_id")
    end

    def id
      group_id
    end

    def name
      group['name']
    end

    def set_state(state)
      body = {
        :desired_state => {
          :powered => !!state
        }
      }

      response = client.post('/groups{/group}/activate', :group => group_id, :body => body))
      response.success?
    end

  end
end
