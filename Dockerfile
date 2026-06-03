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

RUN wget https://repo1.maven.org/maven2/net/java/dev/jna/jna/5.13.0/jna-5.13.0.jar

RUN wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.96/bin/apache-tomcat-8.5.96.tar.gz && \
    tar -xzf apache-tomcat-8.5.96.tar.gz

RUN cp /opt/jna-5.13.0.jar /opt/apache-tomcat-8.5.96/lib/

RUN wget https://archive.apache.org/dist/axis/axis2/java/core/1.7.9/axis2-1.7.9-war.zip && \
    unzip axis2-1.7.9-war.zip && \
    mkdir -p /opt/apache-tomcat-8.5.96/webapps/axis2 && \
    cd /opt/apache-tomcat-8.5.96/webapps/axis2 && \
    jar xf /opt/axis2.war

WORKDIR /app

COPY . .

RUN mkdir -p cobol/bin && \
    for file in cobol/src/*.cbl; do \
        name=$(basename "$file" .cbl); \
        cobc -free -m "$file" -o "cobol/bin/$name"; \
    done

RUN mkdir -p axis2/build/classes && \
    javac \
    -cp /opt/jna-5.13.0.jar \
    -d axis2/build/classes \
    axis2/services/BankService/*.java \
    axis2/services/utils/*.java

RUN mkdir -p axis2/build/tmp/META-INF && \
    cp axis2/services/BankService/services.xml \
    axis2/build/tmp/META-INF/ && \
    cp -r axis2/build/classes/* axis2/build/tmp/ && \
    cd axis2/build/tmp && \
    jar cvf ../BankService.aar *

RUN cp /app/axis2/build/BankService.aar \
    /opt/apache-tomcat-8.5.96/webapps/axis2/WEB-INF/services/BankService.aar && \
    ls -l /opt/apache-tomcat-8.5.96/webapps/axis2/WEB-INF/services/

RUN chmod +x cobol/bin/*

EXPOSE 8080

COPY docker-entrypoint.sh /app/docker-entrypoint.sh

RUN chmod +x /app/docker-entrypoint.sh

ENTRYPOINT ["/app/docker-entrypoint.sh"]
