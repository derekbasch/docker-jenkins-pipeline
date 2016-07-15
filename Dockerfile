FROM jenkinsci/jenkins:2.7

USER root

# installed maven package is still 3.0.5, pretty old
ENV MAVEN_VERSION 3.3.9
RUN cd /usr/local; wget -O - http://mirrors.ibiblio.org/apache/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xvzf -
RUN ln -sv /usr/local/apache-maven-$MAVEN_VERSION /usr/local/maven

WORKDIR /tmp/files

COPY plugins.txt .
RUN /usr/local/bin/plugins.sh plugins.txt

ADD JENKINS_HOME /usr/share/jenkins/ref

USER root
RUN chown -R jenkins.jenkins /usr/share/jenkins/ref
COPY run.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/run.sh

USER jenkins
CMD /usr/local/bin/run.sh

EXPOSE 8080