#!/usr/bin/env ruby
require 'daemons'
pwd  = File.dirname(File.expand_path(__FILE__))
file = pwd + '/emulator.rb'
Daemons.run_proc(
    'emulator_service',
    :log_output => true
) do
  exec "ruby #{file}"
end