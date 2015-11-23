FROM tuxmonteiro/ubuntu-orajdk8

MAINTAINER Marcelo Teixeira Monteiro

ENV MAXCONN 300
ENV INTERVAL 1000
ENV PORT 8080
ENV VERSION 3.1.9-SNAPSHOT

ADD start.sh /usr/bin/
ADD log4j.xml /tmp/
ADD hazelcast.xml /tmp/

RUN apt-get update && \
    apt-get -y install git && \
    chmod +x /usr/bin/start.sh && \
    useradd -m -u 1000 -d /home/galeb galeb

EXPOSE 8080

WORKDIR /home/galeb

USER galeb

CMD ["/usr/bin/start.sh"]

