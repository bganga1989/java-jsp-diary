FROM tomcat:9
COPY target/*.war /usr/local/tomcat/webapps/java-jsp-diary.war
ENV name lucky
