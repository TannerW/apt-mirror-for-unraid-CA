FROM ubuntu:21.04
Maintainer Tanner Wilkerson <tanner.wilkerson@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install --no-install-recommends -y apt-mirror
RUN apt-get install --no-install-recommends -y apache2
RUN apt-get install --no-install-recommends -y vim
RUN apt-get install --no-install-recommends -y cron

EXPOSE 80

RUN mkdir -p /var/www/html/ubuntu
RUN chown www-data:www-data /var/www/html/ubuntu

RUN mv /etc/apt/mirror.list /mirror.list-bak
RUN apt-get autoclean
RUN rm -rf /var/lib/apt/lists/*

COPY mirror.list /etc/apt/mirror.list

RUN mkdir -p /var/www/html/ubuntu/var
RUN cp /var/spool/apt-mirror/var/postmirror.sh /var/www/html/ubuntu/var

# RUN apt-mirror

RUN service apache2 start
# Copy apt-mirror-cron file to the cron.d directory
COPY apt-mirror-cron /etc/cron.d/apt-mirror-cron

RUN chmod 0644 /etc/cron.d/apt-mirror-cron
RUN crontab /etc/cron.d/apt-mirror-cron

COPY cnf.sh /cnf.sh


CMD ["cron", "-f"]