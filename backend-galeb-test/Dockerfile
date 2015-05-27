FROM ubuntu:vivid

MAINTAINER Marcelo Teixeira Monteiro

ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
ENV INITRD no

WORKDIR /root

RUN apt-get install -y nginx ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /srv/html && \
    if [ ! -f /srv/html/index.html ]; then \
        echo "Hello Galeb!!!" > /srv/html/index.html; \
    fi

ADD nginx.conf /etc/nginx/

EXPOSE 8081 8082 8083 8084

CMD ["nginx", "-c", "/etc/nginx/nginx.conf"]
