
testing:

curl -X POST 'http://svwap:8081/7' -H 'Content-type: text/xml'  -v -d "`cat content_submit3`"


README

Building Message Bean:
cp ../stomp_message/build/com/ficonab/F*.class build/com/ficonab/
javac -cp $JRUBY_HOME/lib/jruby.jar:$GLASSFISH_ROOT/lib/j2ee.jar:./build -d build com/ficonab/MmscBean.java
cd build
jar cf ../mmscbean.ear .
cd ..
asadmin deploy --host svbalance.cure.com.ph --port 2626 mmscbean.ear
asadmin deploy mmscbean.ear


OLD AUTODEPLOY
cp mmscbean.jar ../../glassfish/domains/domain1/autodeploy/

CLASSPATH:
export CLASSPATH=$CLASSPATH:$GLASSFISH_ROOT/lib/j2ee.jar
export CLASSPATH=$CLASSPATH:$GLASSFISH_ROOT/lib/appserv-rt.jar
export CLASSPATH=$CLASSPATH:$GLASSFISH_ROOT/lib/javaee.jar
export CLASSPATH=$CLASSPATH:$GLASSFISH_ROOT/lib/j2ee-svc.jar
export CLASSPATH=$CLASSPATH:$GLASSFISH_ROOT/lib/appserv-ee.jar
export CLASSPATH=$CLASSPATH:$GLASSFISH_ROOT/lib/activation.jar
export CLASSPATH=$CLASSPATH:/Users/scott/Documents/ror/glassfish/lib/dbschema.jar 
export CLASSPATH=$CLASSPATH:/Users/scott/Documents/ror/glassfish/lib/appserv-admin.jar 
export CLASSPATH=$CLASSPATH:/Users/scott/Documents/ror/glassfish/lib/install/applications/jmsra/imqjmx.jar   
export CLASSPATH=$CLASSPATH:/Users/scott/Documents/ror/glassfish/lib/install/applications/jmsra/imqjmsra.jar

 export CLASSPATH=$CLASSPATH:$GLASSFISH_ROOT/imq/lib/fscontext.jar