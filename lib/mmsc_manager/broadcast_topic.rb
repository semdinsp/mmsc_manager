# Sms stuff for handling sms
#require 'monitor'
require 'thread'
module MmscManager
#braodcast out the mms to a list.
#bad code in the destination management
class BroadcastTopic
 
 attr_accessor :message, :source, :list,  :attempts, :sent, :mms_sender, :arg_hash
  def common_setup(src)
    self.attempts=0
    self.sent=0
    self.source=src
  end
  # initialize with list of destionations, texts  eg different text for each destination
  # initialize with common text and list of destinations
  def initialize(mms_send,src, lst, msg)
    common_setup(src)
    self.mms_sender=mms_send
    self.list=lst
    self.message=msg
    @list_queue=Queue.new
    self.populate_topic(lst) 
    
  #  raise InvalidPrefix.new("invalid prefix: valid prefix area:" + Sms.valid ) if !prefix_test
  end
  
  # populate thread safe queue
  def populate_topic(lst)
    # puts "list is #{lst}"
    self.arg_hash = {:host => 'localhost'}
    #self.mms_sender=MmscManager::MmsSendTopic.new(arg_hash)  
    lst.each {|key|   
      
                 dst =  key
                 send_it(dst) #if SmscManager::Sms.check_destination(dst)
               
               }
   
     sleep(2)  # should we wait till we get receipts for all?
     puts "populate topic sent #{self.sent}"
    sleep(self.attempts*0.5+1) if self.sent!=self.attempts
     puts "populate topic sent after sleep #{self.sent}"
   # self.mms_sender.disconnect_stomp
  end
  def send_it(dst)
  #  puts "hello from send it"
    begin     
         arg_hash[:soap_header]=self.message.soap_header_part
          self.message.destination=dst
          arg_hash[:message]=self.message.get_mms_message
          puts "Message #{arg_hash[:message]}"  if arg_hash[:debug]==true
       #   self.mms_sender.send_mms_receipt(arg_hash)  {|r|  # puts "in receipt handler #{r.to_s}" 
       #                                                 self.sent+=1 }
       self.mms_sender.send_mms(arg_hash)
       self.sent+=1
     self.attempts+=1
     rescue  Exception => e
       self.sent-=1
       puts "bad values dst: #{dst} msg: #{e.message}"
     end
    # self.sms_sender.close_topic
   end
  end
end