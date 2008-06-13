#$:.unshift File.dirname(__FILE__)
#puts "file is #{File.dirname(__FILE__)}"
#require File.dirname(__FILE__)+'/mmsc_manager/mms_stomp_message.rb'
Dir[File.join(File.dirname(__FILE__), 'mmsc_manager/**/*.rb')].sort.each { |lib| require lib }
#require 'mmsc_manager/mms_message'
module MmscManager
  
end