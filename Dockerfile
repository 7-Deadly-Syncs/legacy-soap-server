FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y \
    openjdk-8-jdk \
    gnucobol \
    wget \
    unzip \
    make \
    build-essential

WORKDIR /opt

RUN wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.96/bin/apache-tomcat-8.5.96.tar.gz && \
    tar -xzf apache-tomcat-8.5.96.tar.gz

RUN wget https://archive.apache.org/dist/axis/axis2/java/core/1.7.9/axis2-1.7.9-war.zip && \
    unzip axis2-1.7.9-war.zip

RUN cp axis2-1.7.9/axis2.war apache-tomcat-8.5.96/webapps/

WORKDIR /app

EXPOSE 8080
