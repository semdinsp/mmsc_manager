require 'yaml'
require 'rubygems'
gem 'stomp'
require 'stomp'
require 'stomp'
gem 'stomp_message'
require 'stomp_message'
module MmscManager
class MmscServer < StompMessage::StompServer
  attr_accessor :mmsc_host, :mmsc_port, :mmsc_url
  def initialize(options={})
   # self.model_list = []
   # self.model_list << "sms_log.rb"
    
    self.mmsc_host = options[:mmsc_host] || "10.43.31.202"
     self.mmsc_port = options[:mmsc_port] || "8081"
     self.mmsc_url = options[:mmsc_url] || "/7"
     super(options)
    puts "#{self.class} initializing"
  end
 def archive_sms(res,msg)
   # do I need to do exception handling in here
 #  SmsLog.log_result(res, 'stomp_message', sms)
 end
 def setup_thread_specific_items(mythread_number)
    super(mythread_number)
    puts " ----creating mmsc for #{get_id}"
     self.variables[get_id][:mmsc]= MmscManager::MmscConnection.new(self.mmsc_host, self.mmsc_port, self.mmsc_url)
  end
  def check_response(res,mms)
    if !res.include?('200') and @debug
      # send email
       begin
         puts "about to send email with mms data for debugging as response is #{res}"
         StompMessage::StompSendTopic.send_email_stomp("scott.sproule@cure.com.ph",
                 "MMSC Debug Problem", "scott.sproule@cure.com.ph","Thread: #{get_id} :debug result messag #{res}", mms.get_mms_message)
       rescue Exception => e
          puts "Can not send email, please check smtp host setting or #{e.message}"
       end
    end
  end
  def stomp_MMS(msg, stomp_msg)
     puts "about to process msg is #{stomp_msg.body}"
     mms=MmscManager::MmsStompMessage.load_xml(stomp_msg.body)
      puts "#{get_id}sending mms #{mms.get_mms_message}" if @debug
     res= self.variables[get_id][:mmsc].post_mms(mms)
     puts "#{get_id} #{res}"
     #archive_sms(res,sms)
      check_response(res,mms)
      reply_msg = StompMessage::Message.new('stomp_REPLY', res)
      [true, reply_msg]
  end
  
end # smsc listener

end #module
