require 'rubygems'
gem 'stomp'
require 'stomp'
gem 'stomp_message'
require 'stomp_message'
# This sends the subscription request to a activemq topic
module MmscManager
class MmsSendTopic < StompMessage::StompSendTopic
  
  #need to define topic, host properly
  @@TOPIC='mms'
  # must be defined as method in sms_listener
  @@STOMP_SUB_MESSAGE='stomp_MMS'
 def initialize(options={})
   # set up variables using hash
    options[:topic] =   options[:topic]==nil ? @@TOPIC : options[:topic]
   
    super(options)
    
    #puts "#{self.class}: finished initializing"
  end

  def create_mms_message(arg_hash)
	   m=MmscManager::MmsStompMessage.new(@@STOMP_SUB_MESSAGE, arg_hash[:message], arg_hash[:soap_header])
       m
  end
  def send_mms_response_from_mms(mms)
      arg_hash={}
      arg_hash[:soap_header]=mms.soap_header_part
      arg_hash[:message]=mms.get_mms_message
      self.send_mms_response(arg_hash)
  end
  def stomp_interim(args)
    header={}
    timeout=75
    msg_received_flag=result=false
    m=create_mms_message(args)
    self.send_topic_acknowledge(m,header,timeout-1)  {   |msg| # puts 'in handle action block' 
                         # puts "MESSAGE RECEIVED ---- #{msg.to_s} "
                          msg_received_flag=true
                          m=StompMessage::Message.load_xml(msg)
                          result=m.body
                        #  puts "result is #{result}"
                          result
                           }
                      begin
                     Timeout::timeout(timeout) {
                           while true  
                            #  putc '.'
                              break if msg_received_flag
                              sleep(1)
                              end  }
                        rescue SystemExit
                        rescue Timeout::Error
                        rescue Exception => e
                         puts "exception #{e.message} class: #{e.class}"
                         puts  "no receipt"
                        end
     # puts "result is now #{result}"
  end
  def send_mms_response(args)
      result2=false
      
     
      if self.java?
        result2=send_mms_jms_ack(args)
      else
        result2=stomp_interim(args)
      end
        result2
  end
  def send_mms_jms_ack(args)
     
      m=create_mms_message(args)
       puts "message is: xml start<: #{m.to_xml} :>xml end" if args[:debug]
      header={}
      timeout=200
      result = self.send_topic_ack(m,header,timeout-1)  
      result
  end
  def send_mms(args)
         m=create_mms_message(args)
         puts "message is #{m.to_xml}"
         headers = {}
         send_topic(m, headers)     
  end #send subscriptiion
  def send_mms_receipt(args, &r_block)
          m=create_mms_message(args)
          headers = {}
         send_topic(m, headers, &r_block)     
  end #send_sms
 
end # smsc listener

end #module
