module NightlightEmulator
  # Container class which groups all cloud connection parameters.
  class ConnectionSetup
    attr_accessor :origin, :publishKey, :subscribeKey, :backend 

    def initialize(origin, publishKey, subscribeKey, backend)
      @origin = origin
      @publishKey = publishKey
      @subscribeKey = subscribeKey
      @backend = backend
    end
    
    def clone
      ConnectionSetup.new(@origin.clone, @publishKey.clone, @subscribeKey.clone, @backend.clone)
    end
  end
end
