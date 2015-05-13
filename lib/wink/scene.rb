module Wink
  class Scene
    attr_reader :client
    attr_reader :scene
    attr_reader :scene_id

    def initialize(client, scene)
      @client = client
      @scene = scene

      @scene_id  = scene.fetch("scene_id")
    end

    def id
      scene_id
    end

    def name
      scene['name']
    end

    def activate
      client.post('/scenes{/scene}/activate', :scene => scene_id)
    end
  end
end
