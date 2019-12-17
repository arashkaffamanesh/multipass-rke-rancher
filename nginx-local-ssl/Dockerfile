FROM ubuntu:18.04

MAINTAINER Kubernauts

# install nginx
RUN apt-get update -y
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:nginx/stable
RUN apt-get update -y
RUN apt-get install -y nginx

# deamon mode off
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
RUN chown -R www-data:www-data /var/lib/nginx

# expose ports
EXPOSE 80 443

# add nginx conf
ADD nginx.config /etc/nginx/sites-available/nginx.local

# create symlinks
RUN ln -s /etc/nginx/sites-available/nginx.local /etc/nginx/sites-enabled/nginx.local

# add server certs
ADD server.crt /etc/nginx/certs/server.crt
ADD server.key /etc/nginx/certs/server.key

WORKDIR /etc/nginx

CMD ["nginx"]
