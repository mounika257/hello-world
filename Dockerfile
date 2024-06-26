FROM centos

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
# Copy web application files to Tomcat webapps directory

RUN cp tomcat-users.xml /opt/tomcat/conf/tomcat-users.xml &&\
    cp context.xml /opt/tomcat/webapps/manager/META-INF/context.xml &&\
    cp contexth.xml /opt/tomcat/webapps/host-manager/META-INF/context.xml
    
WORKDIR /opt/tomcat
# Expose the necessary port and define the entry point
EXPOSE 8080
CMD ["/opt/tomcat/bin/catalina.sh", "run"]
