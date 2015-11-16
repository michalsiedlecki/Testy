module NightlightEmulator
  # Container class which groups all device info
  # which define device identity and version.
  class DeviceInfo
    attr_accessor :serialNb, :swVersion, :deviceId, :channel, :token

    def initialize(serialNb, swVersion, deviceId, channel, token)
      @serialNb = serialNb
      @swVersion = swVersion
      @deviceId = deviceId
      @channel = channel
      @token = token
    end

    def clone
      DeviceInfo.new(@serialNb.clone, @swVersion.clone, @deviceId, @channel.clone, @token.clone)
    end
  end
end
