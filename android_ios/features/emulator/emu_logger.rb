require "logger"

module NightlightEmulator
  # Logger object common for +NightlightEmulator+ module.
  $LOG = Logger.new(STDOUT)
end
