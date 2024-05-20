# Stage 1: Set up Tomcat
FROM centos AS tomcat_setup

# Install necessary packages
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* && \
    yum -y install java && \
    yum clean all

# Set up Tomcat
RUN mkdir -p /opt/tomcat
WORKDIR /opt/tomcat
RUN curl -O https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.89/bin/apache-tomcat-9.0.89.tar.gz && \
    tar -xvzf apache-tomcat-9.0.89.tar.gz && \
    mv apache-tomcat-9.0.89/* /opt/tomcat/ && \
    rm apache-tomcat-9.0.89.tar.gz

# Stage 2: Copy WAR file into Tomcat
FROM tomcat_setup AS war_copy

WORKDIR /opt/tomcat

# Copy additional configuration files if needed
COPY tomcat-users.xml /opt/tomcat/conf/
COPY context.xml /opt/tomcat/webapps/manager/META-INF/
COPY contexth.xml /opt/tomcat/webapps/host-manager/META-INF/

# Copy the webapp.war from local to Tomcat webapps directory
COPY /var/lib/jenkins/workspace/pipeline/webapp/target/webapp.war /opt/tomcat/webapps/

# Expose the necessary port
EXPOSE 8080

# Define the entry point
CMD ["/opt/tomcat/bin/catalina.sh", "run"]
