require 'rexml/document'
require 'net/http'
require 'socket'
require 'base64'
module MmscManager #:nodoc:
  #build mm7 message
  class MmsMessage
      attr_accessor :source, :destination, :transaction_id, :subject, :expiry, :soap_header_part, :multi_part_header, :content
      # where content is hash of files
      def initialize(src,dest, subject,content)
        self.content=content
        self.source=src
        self.destination=dest
        num=rand*1000000
         # 10e790c:10feb7d6a1c:-7ff5wammp3/192.168.201.23
         t_now=Time.now
         t_expiry=Time.now+ 360000#  (roughly 100 hours or 5 days)
        self.transaction_id="#{num.to_i}:#{t_now.strftime('%d%b%Y')}_/#{Socket.gethostname}"
        puts "source: #{self.source} dest: #{self.destination} tx_id; #{self.transaction_id}"
       # expiry format 2007-11-20T13:20:54+08:00
        build_expiry(t_expiry)
          #  header_part = "------=_Part_0_24807938.1166753497728"
         t_header=t_now.strftime('%Y%m%d%H%M%S')
        self.soap_header_part = "------=_Part_0_#{num.to_i}.#{t_header}"
         num=rand*1000000
        self.multi_part_header = "------=_Part_6_#{num.to_i}.#{t_header}"
       # self.header_part = "------=_Part_0_24807938.1166753497728"
        puts "header_part #{self.soap_header_part} multi_part #{self.multi_part_header}"
        self.subject=subject
      end
      # use this to override expiry time after initialization of mms mess
      def build_expiry(t_expiry)
         self.expiry = "#{t_expiry.strftime('%Y-%m-%dT%H:%M:%S+08:00')}"
      end
     def self.build_text_content(text, mimetype='text/plain')
       content ={}
        number=rand*20
        filename="text#{number.to_i}.txt"
        content[:mimetype] =mimetype
        content[:name]=filename
         content[:encoding]='7bit'
        content[:filename]=filename
        content[:cid]=filename
        content[:value] = text << "\r\n"
        content
     end
      def self.build_html_content(text)
         build_text_content(text,'text/html')
      end
      def self.build_image_content(data, format='jpeg', filename=nil)
        content ={}
         number=rand*50
         filename="text#{number.to_i}.jpg" if filename==nil
         content[:mimetype] ='image/jpeg'
         content[:name]=filename
          content[:encoding]='base64'
         content[:filename]=filename
         content[:cid]=filename
         encoded=Base64.encode64(data)
         content[:value] = encoded
         content
      end
     def to_xml_soap_envelope
       
    #    10e790c:10feb7d6a1c:-7ff5wammp3/192.168.201.23  Transaction id   #{self.transaction_id}
xml_header = <<EOF__RUBY_END_OF_MESSAGE
<?xml version='1.0' ?><env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"><env:Header><mm7:TransactionID xmlns:mm7="http://www.3gpp.org/ftp/Specs/archive/23_series/23.140/schema/REL-5-MM7-1-3">#{self.transaction_id}</mm7:TransactionID></env:Header><env:Body><SubmitReq xmlns="http://www.3gpp.org/ftp/Specs/archive/23_series/23.140/schema/REL-5-MM7-1-3"><MM7Version>5.3.0</MM7Version><SenderIdentification><VASPID>testvasp</VASPID><VASID>testvas</VASID><SenderAddress><Number>#{self.source}</Number></SenderAddress></SenderIdentification><Recipients><To><Number>00#{self.destination}</Number></To></Recipients><MessageClass>Personal</MessageClass><ExpiryDate>#{self.expiry}</ExpiryDate><DeliveryReport>false</DeliveryReport><ReadReply>false</ReadReply><Priority>Low</Priority><Subject>#{self.subject}</Subject><DistributionIndicator>true</DistributionIndicator><Content href="cid:generic_content_id" /></SubmitReq></env:Body></env:Envelope>

EOF__RUBY_END_OF_MESSAGE
          # <ExpiryDate>2007-01-20T13:20:54+08:00</ExpiryDate>
       
        output =""
        output << xml_header
        output
       # doc= REXML::Document.new sms_xml.to_s
       # doc.to_s
      end
def soap_envelope
soap_envelope = <<XML_EOF_SOAP_ENV
#{self.soap_header_part}
Content-Type: text/xml; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

XML_EOF_SOAP_ENV

soap_envelope
end
def msg_content_header
    # CAUTION MUST DROP FIRST TWO CHARs
      short_multi = self.multi_part_header[2..self.multi_part_header.size]
      # spacing is important... SIGH!!!! and BLANKS!!! if you can believe that...
msg_content_header = <<XML_EOF_MESSAGE_CONTENT
#{self.soap_header_part}
Content-Type: multipart/mixed; boundary="#{short_multi}"
Content-ID: <generic_content_id>

XML_EOF_MESSAGE_CONTENT
msg_content_header

end
#content is array of hashes of which 
# cid is content id  eg text.txt
# name is content name
# mimetype is content mimetpye eg text/plan
# value is contents   (may need 64 bit encoding, etc.)
# enncoding  is enconding like 7b or 64bit
      def create_mms_content(content)
        result = ""
         # original  ------=_Part_0_24807938.1166753497728
         #original Content-Type: text/xml; charset=UTF-8
         #original Content-Transfer-Encoding: quoted-printable
       # soap_header_part = self.header_part
       
       content.each { |content| 
          	content_msg = <<EOF__RUBY_END_OF_MESSAGE
          	
#{self.multi_part_header}
Content-Type: #{content[:mimetype]}; name=#{content[:name]}
Content-Transfer-Encoding: #{content[:encoding]}
Content-Disposition: attachment; filename=#{content[:filename]}
Content-ID: <#{content[:cid]}>

#{content[:value]}  

EOF__RUBY_END_OF_MESSAGE
        #  puts "building message #{sms_msg}"
          result << "#{content_msg}"   
           } if content !=nil
     result      
end 

def xml_close_body

xml_close_body = <<XML_EOF_BODY_CLOSE

#{self.multi_part_header}--

#{self.soap_header_part}-- 

XML_EOF_BODY_CLOSE
xml_close_body
end
       
      def build_MMS_message(content=nil)
         result = ""
         result << soap_envelope
         temp=[]
         temp[0]=self.to_xml_soap_envelope
         #not ceertain about this 74... pretty strange but it works
         result << temp.pack("M74")
          result << msg_content_header
         result << create_mms_content(self.content)
          result << xml_close_body
          result.gsub!(/\n/,"\r\n")   #move to \r\n
          result
      end
      #build xml message formatted for mm7 delivery
      def get_mms_message
        #encoded=Base64.encode64(s)
        return self.build_MMS_message(self.content)
      end
       def get_message_content   #used elsewhere
          return self.create_mms_content(self.content)
       end
       #build xml message formatted for mm7 delivery
        def get_mms_message_encode64
          #encoded=Base64.encode64(s)
          return Base64.encode64(self.get_mms_message)
        end
      # buildstomp message with mm7 payload
      def get_mms_stomp_message
        return MmscManager::MmsStompMessage.new('stomp_MMS',
                         self.get_mms_message,self.soap_header_part)
      end
      def post_mms(host,port,url)
          mmsc=MmscManager::MmscConnection.new(host, port,url)
          mmsc.post_mms(self)
      end
      
  end
end
