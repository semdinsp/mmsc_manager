require File.dirname(__FILE__) + '/test_helper.rb'

class TestMmscManager < Test::Unit::TestCase

  def setup
   # mmsc_host='svwap.cure.com.ph'
    @mmsc_host='10.43.31.202'
    @mmsc_port=8081
    @mmsc_url= '/7'
  end
  
  def test_mms_message
    c=[]
    m=MmscManager::MmsMessage.new('888','639993130030','hello there',c)
    g=m.build_MMS_message(nil)
    puts"#{g}"
    assert g.include?("xml"), "xml notpart of output"
  
  end
  def test_mms_text
     c=[]
     m=MmscManager::MmsMessage.new('888','639993130030','hello there',c)
     assert m.get_message_content!=nil, 'message content is nil'
   end
  def test_mms_message_content
    c=[]
    c[0]=setup_build_content
    m=MmscManager::MmsMessage.new('888','639993130030','hello there',c)
    g=m.build_MMS_message(nil)
    puts"#{g}"
    assert g.include?("xml"), "xml notpart of output"
  
  end
 
  def test_mms_message_content2
    c=[]
    c[0]=setup_build_content
      c[1]=setup_build_content2
    m=MmscManager::MmsMessage.new('888','639993130030','hello there',c)
    g=m.build_MMS_message(nil)
    puts"#{g}"
    assert g.include?("xml"), "xml notpart of output"
  
  end
  def test_mms_image_content
     c=[]
     c[0]=setup_build_content2
     m=MmscManager::MmsMessage.new('888','639993130030','hello there',c)
      c[0]=MmscManager::MmsMessage.build_image_content(File.read('../monkeysleeping.jpg'), 'jpeg', 'monkeysleeping.jpg')
      m2=MmscManager::MmsMessage.new('888','639993130030','hello there',c)
      
     g=m.build_MMS_message()
     g2=m2.build_MMS_message()
   #  assert g2==g, 'message not same'
   end
  def setup_build_content3
    content ={}
    content[:mimetype] ='text/plain'
    content[:name]='testing1.txt'
     content[:encoding]='7bit'
    content[:filename]='testing1.txt'
    content[:cid]='testing1.txt'
    require 'rubygems'
    gem 'simple_sms_services'
    require 'simple_sms_services'
       feed=SimpleSmsServices::Feed.new('http://www.iht.com/rss/frontpage.xml','ihtkeyword')
    content[:value] = feed.get_data_mms
    content
    end
def setup_build_content
     MmscManager::MmsMessage.build_text_content('hello from build content')
  end 
  def setup_build_content2
    content ={}
    content[:mimetype] ='image/jpeg'
    content[:name]='monkeysleeping.jpg'
     content[:encoding]='base64'
    content[:filename]='monkeysleeping.jpg'
    content[:cid]='monkeysleeping.jpg'
    s=File.read('../monkeysleeping.jpg')
    require 'base64'
    encoded=Base64.encode64(s)
    content[:value] = encoded
    content
    end
     def test_mms_html
           content=[]
           content[0]= MmscManager::MmsMessage.build_html_content('<h1>heading</h1><p>hello from build  html content</p>')

         #   m=MmscManager::MmsMessage.new('888','639993130452','hello there jan from scott')
         #  r= m.post_mms('svwap.cure.com.ph', '8081','/7')
         #   assert r.code=='200',"invalid response from mmsc #{r.code}"
           m=MmscManager::MmsMessage.new('888','639993130030','html content',content)
          puts "ABOUT TO POST"
       #    #post=m.create_post
           puts "SOAP header before post #{m.soap_header_part}"
           r= m.post_mms(@mmsc_host, @mmsc_port,@mmsc_url)
            puts "SOAP header after post #{m.soap_header_part}"
          assert r.include?('HTTPOK 200 OK'),"invalid response from mmsc #{r}"
         end
    def test_mms_post_first
         content=[]
         content[0]=setup_build_content3
       
       #   m=MmscManager::MmsMessage.new('888','639993130452','hello there jan from scott')
       #  r= m.post_mms('svwap.cure.com.ph', '8081','/7')
       #   assert r.code=='200',"invalid response from mmsc #{r.code}"
         m=MmscManager::MmsMessage.new('888','639993130030','hello there from scott',content)
        puts "ABOUT TO POST"
     #    #post=m.create_post
         puts "SOAP header before post #{m.soap_header_part}"
         r= m.post_mms(@mmsc_host, @mmsc_port,@mmsc_url)
          puts "SOAP header after post #{m.soap_header_part}"
        assert r.include?('HTTPOK 200 OK'),"invalid response from mmsc #{r}"
       end
       #10.43.31.202
        def test_mms_post_to_ip
             content=[]
            content[0]=setup_build_content
            content[1]=setup_build_content
           #   m=MmscManager::MmsMessage.new('888','639993130452','hello there jan from scott')
           #  r= m.post_mms('svwap.cure.com.ph', '8081','/7')
           #   assert r.code=='200',"invalid response from mmsc #{r.code}"
             m=MmscManager::MmsMessage.new('888','639993130030','hello there from scott',content)
            puts "ABOUT TO POST"
         #    #post=m.create_post
             puts "SOAP header before post #{m.soap_header_part}"
             r= m.post_mms(@mmsc_host, @mmsc_port,@mmsc_url)
              puts "SOAP header after post #{m.soap_header_part}"
            assert r.include?('HTTPOK 200 OK'),"invalid response from mmsc #{r}"
           end
         def test_mms_post_first2
              content=[]
             content[0]=setup_build_content
             content[1]=setup_build_content
            #   m=MmscManager::MmsMessage.new('888','639993130452','hello there jan from scott')
            #  r= m.post_mms('svwap.cure.com.ph', '8081','/7')
            #   assert r.code=='200',"invalid response from mmsc #{r.code}"
              m=MmscManager::MmsMessage.new('888','639993130030','hello there from scott',content)
             puts "ABOUT TO POST"
          #    #post=m.create_post
              puts "SOAP header before post #{m.soap_header_part}"
              r= m.post_mms(@mmsc_host, @mmsc_port,@mmsc_url)
               puts "SOAP header after post #{m.soap_header_part}"
                assert r.include?('HTTPOK 200 OK'),"invalid response from mmsc #{r}"
            end
   def test_mms_post_new
       content=[]
       content[0]=setup_build_content2
    #   content[1]=setup_build_content2
     #   m=MmscManager::MmsMessage.new('888','639993130452','hello there jan from scott')
     #  r= m.post_mms('svwap.cure.com.ph', '8081','/7')
     #   assert r.code=='200',"invalid response from mmsc #{r.code}"
       m=MmscManager::MmsMessage.new('888','639993130030','hello there from scott',content)
      puts "ABOUT TO POST"
   #    #post=m.create_post
       puts "SOAP header before post #{m.soap_header_part}"
       r= m.post_mms(@mmsc_host, @mmsc_port,@mmsc_url)
        puts "SOAP header after post #{m.soap_header_part}"
          assert r.include?('HTTPOK 200 OK'),"invalid response from mmsc #{r}"
     end
     def test_mms_post_email_src
          content=[]
          content[0]=setup_build_content2
       #   content[1]=setup_build_content2
        #   m=MmscManager::MmsMessage.new('888','639993130452','hello there jan from scott')
        #  r= m.post_mms('svwap.cure.com.ph', '8081','/7')
        #   assert r.code=='200',"invalid response from mmsc #{r.code}"
          m=MmscManager::MmsMessage.new('scott.sproule@gmail.com','639993130030','hello there from scott',content)
         puts "ABOUT TO POST"
      #    #post=m.create_post
          puts "SOAP header before post #{m.soap_header_part}"
          r= m.post_mms(@mmsc_host, @mmsc_port,@mmsc_url)
           puts "SOAP header after post #{m.soap_header_part}"
             assert r.include?('HTTPOK 200 OK'),"invalid response from mmsc #{r}"
        end
     def test_mms_post_mmsc
          content=[]
          content[0]=setup_build_content
    
          m=MmscManager::MmsMessage.new('888','639993130030','hello there from scott',content)
            
          mmsc=MmscManager::MmscConnection.new(@mmsc_host, @mmsc_port,@mmsc_url)
          r=mmsc.post_mms(m)
          assert r.include?('HTTPOK 200 OK'),"invalid response from mmsc #{r}"
        end
        def test_mms_broadcast
              content=[]
              content[0]=setup_build_content

              m=MmscManager::MmsMessage.new('888','639993130030','hello there from scott',content)
               list = %w(639993130030 639993130030)
              b=MmscManager::BroadcastTopic.new('888',list ,m)
                assert b.attempts==2,"did not try 2"
                assert b.sent==2,"did not send 2"
            end
 def test_mms_stomp_messages
        content=[]
        content[0]=setup_build_content
        m=MmscManager::MmsMessage.new('888','639993130030','hello there from scott',content)
        stomp_m = MmscManager::MmsStompMessage.new('stomp',m.get_mms_message,m.soap_header_part)
        assert m.get_mms_message==stomp_m.get_mms_message, 'body wrong'
        stomp2 = m.get_mms_stomp_message
       # assert stomp2.to_xml==stomp_m.to_xml, "xml wrong  #{stomp2.to_xml} versus #{stomp_m.to_xml}"   never the same as part is random
      end
end
