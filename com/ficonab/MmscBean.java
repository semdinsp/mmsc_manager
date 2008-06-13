package com.ficonab;

import javax.jms.MessageListener;
import com.ficonab.FiconabBase;

//@MessageDriven(mappedName = "mms")	
public class MmscBean extends FiconabBase  implements MessageListener{
	public  String get_topic() { return "mms"; }
	public String get_bootstrap_string() {
	String bootstrap_string = "gem 'mmsc_manager' \nrequire 'mmsc_manager'\n MmscManager::MmscServer.new({:topic => 'mms', :jms_source => 'mmscserver'})"; 
	    return bootstrap_string;
	}
	

}