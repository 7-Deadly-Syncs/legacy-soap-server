FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y \
    openjdk-8-jdk \
    open-cobol \
    wget \
    unzip \
    make \
    build-essential && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt

RUN wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.96/bin/apache-tomcat-8.5.96.tar.gz && \
    tar -xzf apache-tomcat-8.5.96.tar.gz

RUN wget https://archive.apache.org/dist/axis/axis2/java/core/1.7.9/axis2-1.7.9-war.zip && \
    unzip axis2-1.7.9-war.zip && \
    cp axis2.war apache-tomcat-8.5.96/webapps/

WORKDIR /app

COPY . .

RUN mkdir -p cobol/bin && \
    cobc -x cobol/balance.cbl -o cobol/bin/balance

RUN mkdir -p axis2/build && \
    cd axis2/services/BankService && \
    jar cvf ../../build/BankService.aar *

RUN cp axis2/build/BankService.aar \
    /opt/apache-tomcat-8.5.96/webapps/axis2/WEB-INF/services/

RUN chmod +x cobol/bin/*

EXPOSE 8080

CMD ["/opt/apache-tomcat-8.5.96/bin/catalina.sh", "run"]
