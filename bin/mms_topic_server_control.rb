#!/usr/bin/env ruby
require 'optparse'
require 'rubygems'
gem 'mmsc_manager'
require 'mmsc_manager'
gem 'daemons'
require 'daemons'
 puts "#{ARGV[0]} MMS Topic server:"
  #  begin
  options = {
  #  :ontop => true,
  #  :multiple => true,
    :monitor => true
    
  }
     Daemons.run(File.join(File.dirname(__FILE__), 'mms_topic_server.rb'), options)
     
        

   
    
