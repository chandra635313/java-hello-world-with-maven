FROM maven:3.8.6-openjdk-8

# Install required packages
RUN apt-get update && apt-get install -y wget git

# --------------------------------------------------
# Clone application source
# --------------------------------------------------
WORKDIR /opt
RUN git clone https://github.com/chandra635313/java-hello-world-with-maven.git

# --------------------------------------------------
# Build WAR file
# --------------------------------------------------
WORKDIR /opt/java-hello-world-with-maven
RUN mvn clean package

# --------------------------------------------------
# Download & extract Tomcat
# --------------------------------------------------
WORKDIR /opt
RUN wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.3/bin/apache-tomcat-8.5.3.tar.gz \
 && tar -xvf apache-tomcat-8.5.3.tar.gz

# --------------------------------------------------
# Configure Tomcat users (Manager login)
# --------------------------------------------------
RUN echo '<?xml version="1.0" encoding="UTF-8"?> \
<tomcat-users> \
  <role rolename="manager-gui"/> \
  <role rolename="admin-gui"/> \
  <user username="admin" password="admin123" roles="manager-gui,admin-gui"/> \
</tomcat-users>' > /opt/apache-tomcat-8.5.3/conf/tomcat-users.xml

# --------------------------------------------------
# Allow remote access to Tomcat Manager (403 fix)
# --------------------------------------------------
RUN sed -i 's/<Valve className="org.apache.catalina.valves.RemoteAddrValve".*/<!-- RemoteAddrValve disabled -->/' \
 /opt/apache-tomcat-8.5.3/webapps/manager/META-INF/context.xml

RUN sed -i 's/<Valve className="org.apache.catalina.valves.RemoteAddrValve".*/<!-- RemoteAddrValve disabled -->/' \
 /opt/apache-tomcat-8.5.3/webapps/host-manager/META-INF/context.xml

# --------------------------------------------------
# Deploy application as /hello
# --------------------------------------------------
RUN cp /opt/java-hello-world-with-maven/target/*.war \
 /opt/apache-tomcat-8.5.3/webapps/hello.war

# --------------------------------------------------
# Expose port & start Tomcat
# --------------------------------------------------
EXPOSE 8080
CMD ["/opt/apache-tomcat-8.5.3/bin/catalina.sh", "run"]
