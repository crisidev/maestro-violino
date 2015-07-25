FROM hub.maestro.io:5000/crisidev/debian
MAINTAINER Matteo Bigoi bigo@crisidev.org

RUN apt-get update
RUN apt-get install -y nginx curl vim

WORKDIR /usr/local/bin
RUN curl -L https://github.com/kelseyhightower/confd/releases/download/v0.10.0/confd-0.10.0-linux-amd64 -o confd
ADD confd-watch confd-watch
RUN chmod +x confd confd-watch
RUN mkdir -p /etc/confd/conf.d /etc/confd/templates

WORKDIR /etc/confd/conf.d
ADD nginx.toml nginx.toml
ADD scraper.toml scraper.toml

WORKDIR /etc/confd/templates
ADD nginx.tmpl nginx.tmpl
ADD scraper.tmpl scraper.tmpl

WORKDIR /etc/nginx/sites-available
ADD default.conf default

WORKDIR /etc/nginx
ADD nginx.conf nginx.conf

WORKDIR /var/www/html
ADD index.html index.html
ADD maestro.jpg maestro.jpg
ADD back.jpg back.jpg

WORKDIR /etc/confd
RUN mkdir violino
CMD /usr/local/bin/confd-watch
