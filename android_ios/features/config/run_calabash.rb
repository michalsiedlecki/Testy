#!/usr/bin/env ruby
require 'fileutils'

FileUtils.ln_s('features/config/Gemfile', 'Gemfile', :force=>true)
FileUtils.ln_s('features/config/cucumber.yml', 'cucumber.yml', :force=>true)

unless system("bundle --version")
  puts "Can't find bundler. Check your ruby environment."
  exit(false)
else
  system("bundle install --quiet")
end

if ARGV.empty?
  puts "Missing argument(s)"
  exit
else
  target = ARGV.shift
  if target.include?("android")
    exec("calabash-android run ../../Leeo\-debug.apk -p #{target} #{ARGV.join(" ")}")
  elsif target.include?("ios")
    if target.include?("iPhone")
      ENV['APP_BUNDLE_PATH']="/Users/Shared/Jenkins/Library/Developer/Xcode/DerivedData/LeeoLight-bmkflsuuhatsrpaaccsfklqnweph/Build/Products/Debug-iphonesimulator/leeo-test-cal.app"
      ENV['DEVICE_TARGET']="c87d76e6bec1944c6c8366812e9a333195985ff1"
      ENV['BUNDLE_ID']="com.leeo.qa"
      ENV['DEVICE_ENDPOINT']="http://192.168.0.112:37265"
    end
    exec("cucumber -p #{target} #{ARGV.join(" ")}")
  end
end
