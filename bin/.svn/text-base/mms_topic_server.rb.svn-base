#!/usr/bin/env ruby
require 'optparse'
def usage
    puts "Usage: mms_topic_server.rb to start up mmsc  " 
#puts "Usage: mms_topic_server.rb path_to_subscriptions_rails_app environment " 
      puts "eg: mms_topic_server.rb ./ development " 
   exit
end

require 'rubygems'
gem 'mmsc_manager'
require 'mmsc_manager'
  # env_setting = ARGV[1] || "production"
  #  path_setting = ARGV[0] || "/opt/local/rails_apps/smsapp/current/"
   puts "Starting MMSC Topic Server topic server:"
   #{}"  path:  #{path_setting} environment: #{env_setting}"
   # mmsc_host='svwap.cure.com.ph'
     mmsc_host='10.43.31.202'
    #  MmscManager::Mmscserver.new({:topic => '/topic/mms', :thread_count => '4', :env => env_setting, :root_path => path_setting }).run
    MmscManager::MmscServer.new({:topic => '/topic/mms', :thread_count => '4', :mmsc_host => mmsc_host, :mmsc_port => '8081', :mmsc_url => '/7'}).run
  
   
    
