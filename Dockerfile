FROM jenkinsci/jenkins:2.7

USER root

# installed maven package is still 3.0.5, pretty old
ENV MAVEN_VERSION 3.3.9
RUN cd /usr/local; wget -O - http://mirrors.ibiblio.org/apache/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xvzf -
RUN ln -sv /usr/local/apache-maven-$MAVEN_VERSION /usr/local/maven

WORKDIR /tmp/files

# Prepare local Maven repo. Note that $JENKINS_HOME is a volume so we cannot populate it now.
RUN mkdir repo-wc
# ADD repo/src repo-wc/src
ADD repo/pom.xml repo-wc/pom.xml
ADD repo repo-wc
RUN chown -R jenkins.jenkins .
USER jenkins
RUN echo '<settings><mirrors><mirror><id>central</id><url>http://repo.jenkins-ci.org/simple/repo1-cache/</url><mirrorOf>central</mirrorOf></mirror></mirrors><localRepository>/usr/share/jenkins/ref/.m2/repository</localRepository></settings>' > settings.xml
RUN /usr/local/maven/bin/mvn -X -s settings.xml -f repo-wc -Dmaven.test.failure.ignore clean install

COPY plugins.txt .
RUN /usr/local/bin/plugins.sh plugins.txt

# Now copy the complete repo including Pipeline script (not only the files needed to warm up the Maven cache).
RUN rm -rf repo-wc
ADD repo repo-wc
USER root
RUN chown -R jenkins.jenkins repo-wc
USER jenkins
RUN git init --bare repo && \
    cd repo-wc && \
    git init && \
    git add . && \
    git -c user.email=demo@jenkins-ci.org -c user.name="Pipeline Demo" commit -m 'demo' && \
    git push ../repo master && \
    cd .. && \
    rm -rfv repo-wc
# TODO deletion of repo-wc does not seem to work: claims to have been deleted, but then still there in subsequent steps; anyway it is small
# RUN ls -lRa; false

ADD JENKINS_HOME /usr/share/jenkins/ref

USER root
RUN chown -R jenkins.jenkins /usr/share/jenkins/ref
COPY run.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/run.sh

USER jenkins
CMD /usr/local/bin/run.sh

EXPOSE 8080 9418