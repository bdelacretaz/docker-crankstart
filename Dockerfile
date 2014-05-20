# Dockerfile that runs a Sling crankstart instance
#
# Starting from a fresh docker install you 
# can run this as follows:
#
#   docker pull base
#   docker run base /bin/echo docker works!
#   # adapt URLs in this file (mongo, ZK etc)
#   docker build .
#   # note the image <id> that this returns
#   docker run -v  /usr/local/sling <id> -t -i
#
# Use docker ps to see what's running and 
# docker stop <container id> to stop
#
# To share folders with the host use -v, like:
# 
#  docker run -v <your-sling-data-folder>:/usr/local/sling/sling:rw <image ID>
#
# as per http://docs.docker.io/en/latest/use/working_with_volumes/
#
FROM base
MAINTAINER bdelacretaz@apache.org
RUN apt-get -qq update
RUN apt-get install -y openjdk-7-jre-headless wget
RUN mkdir /usr/local/sling
WORKDIR /usr/local/sling

# TODO make this configurable
RUN wget https://repository.apache.org/content/repositories/snapshots/org/apache/sling/org.apache.sling.crankstart.launcher/0.0.1-SNAPSHOT/org.apache.sling.crankstart.launcher-0.0.1-20140520.123412-2.jar

ADD crankstart.txt /usr/local/sling/crankstart.txt

# Must be consistent with below options
EXPOSE 8080

# TODO replace 192.168.0.110 with the correct host
# For now this requires some setup on the host which is pointed
# to by the Maven, Mongo and ZK URLs below:
# -start HTTP server on the Maven repository, which must contain the appropriate snapshots
# -start mongod
# -start ZK
CMD java  -Dorg.ops4j.pax.url.mvn.localRepository=./maven-repo -Dorg.ops4j.pax.url.mvn.repositories=http://repo1.maven.org/maven2@id=central,http://192.168.0.110:8000@id=host -Dport=8080 -Dmongo_uri=mongodb://192.168.0.110:27017 -Dmongo_db=oak -Dsling.devops.zookeeper.connString=192.168.0.110:2181 -jar org.apache.sling.crankstart.launcher-*.jar crankstart.txt
