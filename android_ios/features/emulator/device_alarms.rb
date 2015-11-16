module NightlightEmulator
  # Container class which groups all alarms and their states.
  class DeviceAlarms
    # Representation of alarm state.
    # Attributes:
    # +active+:: Indicate if alarm is activated. Change from false to true means triggering alarm.
    #            Other way around does nothing. 
    # +sound+:: Path to the alarm sound file.
    # +storageUrl+:: S3 download url which is posted with alarm.
    # +_id+:: Posted alarms id.
   class State
      attr_accessor :active, :sound, :storageUrl, :_id
  
      def initialize(active = false, sound = nil, storageUrl = nil, _id = nil)
        @active = active
        @sound = sound
        @storageUrl = storageUrl
        @_id = _id
      end

       def clone
         State.new(@active, @sound.nil? ? nil : @sound.clone, @storageUrl.nil? ? nil : @storageUrl.clone, @_id)
       end

      def ==(other)
        @active == other.active and
        @sound == other.sound and
        @storageUrl == other.storageUrl and
        @_id == other._id
      end
    end
    
    attr_accessor :co, :smoke, :sound, :battery

    def initialize(co = nil, smoke = nil, sound = nil, battery = nil)
      @co = co.nil? ? State.new : co
      @smoke = smoke.nil? ? State.new : smoke
      @sound = sound.nil? ? State.new : sound
      @battery = battery.nil? ? State.new : battery
    end

    def clone
      DeviceAlarms.new(@co.clone, @smoke.clone, @sound.clone, @battery.clone)
    end
    
    def ==(other)
      @co == other.co and
      @smoke == other.smoke and
      @sound == other.sound and
      @battery == other.battery
    end
    
    def to_s
      "{
    co => {active => #{@co.active}, sound => #{@co.sound}, storageUrl => #{@co.storageUrl}, _id => #{@co._id}}, 
    smoke => {active => #{@smoke.active}, sound => #{@smoke.sound}, storageUrl => #{@smoke.storageUrl}, _id => #{@smoke._id}},
    sound => {active => #{@sound.active}, sound => #{@sound.sound}, storageUrl => #{@sound.storageUrl}, _id => #{@sound._id}},
    battery => {active => #{@battery.active}, sound => #{@battery.sound}, storageUrl => #{@battery.storageUrl}, _id => #{@battery._id}}
  }"
    end
  end
end
