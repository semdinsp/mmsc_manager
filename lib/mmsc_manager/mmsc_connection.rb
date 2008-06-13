require 'rexml/document'
require 'net/http'
require 'socket'
module MmscManager #:nodoc:
  #build mm7 message
  class MmscConnection
      attr_accessor :host, :port, :url
      # where content is hash of files
      def initialize(hst,p,url)
        self.host=hst
        self.port=p
        self.url =url
        puts "#{self.class}: initialized on #{self.host}:#{self.port} url: #{self.url}"
      end
      def post_mms(message)
        
        #testng curl -X POST 'http://svwap:8081/7' -H -H 'Content-type: text/xml'  -v -d "`cat content_submit`"
       
                puts "header part is #{message.soap_header_part}"
                # CAUTION- DELETING FIRST TWO DIGITS CRITIcAL
                head_string=message.soap_header_part[2..message.soap_header_part.size]
                 content_type_text ="multipart/related; boundary=\"#{head_string}\""
                 puts "content type is: #{content_type_text}"
                 response_header = {"Content-type" => content_type_text, 'Expect' => "100-continue"}
                 #response_header.merge headers
                 r=""
                 begin 
                     puts "host is #{self.host}, port is #{self.port}"
                     ht =Net::HTTP.start(self.host,self.port)
                     puts "started Network "
                     r=ht.post(self.url,message.get_mms_message,response_header)
                     r = "result: #{r.code} #{r.inspect}"
                 rescue Exception => e
                   puts "exception found in mmsc connection"
                   r=e.message
                 end
                 r
      end
      
  end
end
