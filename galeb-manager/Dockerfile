FROM tuxmonteiro/ubuntu-orajdk8

MAINTAINER Marcelo Teixeira Monteiro

ENV PORT 8000
ENV VERSION 1.0.6-SNAPSHOT
ENV GALEB_DB_SHOWSQL=false
ENV GALEB_DB_DRIVER=com.mysql.jdbc.Driver
ENV GALEB_DB_DIALECT=org.hibernate.dialect.MySQL5Dialect
ENV GALEB_DB_DDL_AUTO=validate

ADD start.sh /usr/bin/
ADD log4j.xml /tmp/

RUN apt-get update && \
    apt-get -y install git && \
    chmod +x /usr/bin/start.sh && \
    useradd -m -u 1000 -d /home/galeb galeb

EXPOSE 8000

WORKDIR /home/galeb

USER galeb

CMD ["/usr/bin/start.sh"]

