# basic format for stomp messages
require 'rexml/document'
require 'rubygems'
gem 'stomp_message'
require 'base64'
require 'stomp_message'
module MmscManager
	class MmsStompMessage < StompMessage::Message
	  attr_accessor :soap_header_part, :mms_message
	  def initialize(cmd, msg ,soap)
	    self.soap_header_part = soap
	    # message should be plain text
	   # self.mms_message_encoded=Base64.encode64(msg)
	   self.mms_message=msg
	     #super(cmd,body_to_xml)
	      super(cmd)
	  end
    def get_mms_message
      #return Base64.decode64(self.mms_message_encoded)
       return self.mms_message
    end
    def self.load_xml(xml_string)
      doc=REXML::Document.new(xml_string)
      soap=REXML::XPath.first(doc, "//soap_header_part").text
      cmd = REXML::XPath.first(doc, "//__stomp_msg_command").text
      msg = REXML::XPath.first(doc, "//mms_message").text
      mms=MmscManager::MmsStompMessage.new(cmd,msg,soap)
    end
	end
end