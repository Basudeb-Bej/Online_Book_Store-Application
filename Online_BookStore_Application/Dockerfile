FROM tomcat:10.1-jdk17-temurin

# Remove default Tomcat applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Deploy the Book Store application
COPY deploy/OnlineBookstore.war /usr/local/tomcat/webapps/ROOT.war

# Configure Tomcat to use Render's PORT
RUN sed -i 's/port="8080"/port="${PORT:-8080}"/' \
    /usr/local/tomcat/conf/server.xml

EXPOSE 8080

CMD ["catalina.sh", "run"]
