#!/usr/bin/env jruby
# == Synopsis
#   Send a message to a mmsc server , typically to send mms to  a subscriber
# == Usage
#   mms_topic.rb  -m msisdn -S subject  -s src -t text " 
# == Author
#   Scott Sproule  --- Ficonab.com (scott.sproule@ficonab.com)
# == Copyright
#    Copyright (c) 2007 Ficonab Pte. Ltd.
#     See license for license details
require 'rubygems'
gem 'mmsc_manager'
require 'mmsc_manager'
require 'stomp_message'
require 'rdoc/usage'


 arg_hash=StompMessage::Options.parse_options(ARGV)
 RDoc::usage if  arg_hash[:msisdn]==nil || arg_hash[:subject]==nil || arg_hash[:source]==nil
     service=arg_hash[:keyword]
     msisdn=arg_hash[:msisdn]
     content=[]
     content[0]= MmscManager::MmsMessage.build_text_content(arg_hash[:text])
     puts "content[0] is #{content[0].inspect}"
     mms=MmscManager::MmsMessage.new(arg_hash[:source],
                       arg_hash[:msisdn],arg_hash[:subject],content)
     arg_hash[:soap_header]=mms.soap_header_part
      arg_hash[:message]=mms.get_mms_message
      puts "Message #{arg_hash[:message]}"  if arg_hash[:debug]==true
     mmsmgr=MmscManager::MmsSendTopic.new(arg_hash)
     result=mmsmgr.send_mms_response(arg_hash)
     puts "result is #{result}"
    # puts "Response code: #{res.} body: #{res.code}"  if res.kind_of? Net::Http
    exit!
    
