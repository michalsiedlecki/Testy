module NightlightEmulator
  # Container class which groups all device 'dynamic' properties
  # thet represents peripherals state.
  class DeviceState
    attr_accessor :temperature, :humidity, :color, :_alsEnabled, :_alsSuspended, :_testMode

    def initialize(temperature = nil, humidity = nil, color = nil, _alsEnabled = nil, _alsSuspended = nil, _testMode = nil)
      @temperature = temperature.nil? ? 22.5 : temperature
      @humidity = humidity.nil? ? 0.55 : humidity
      @color = color.nil? ? [0.5, 0.7, 0.9] : color
      @_alsEnabled = _alsEnabled.nil? ? true : _alsEnabled
      @_alsSuspended = _alsSuspended.nil? ? false : _alsSuspended
      @_testMode = _testMode .nil? ? false : _testMode
    end
    
    def clone
      DeviceState.new(@temperature, @humidity, @color.clone, @_alsEnabled, @_alsSuspended, @_testMode)
    end
  end
end
