FROM ubuntu:16.04
MAINTAINER Jiahao Wang
ENV REFRESHED_AT 2016-09-20

RUN apt-get update && apt-get install -y openssh-server
RUN apt-get update && apt-get install -y iputils-ping
RUN apt-get update && apt-get install -y netcat-traditional
RUN apt-get update && apt-get install -y expect
RUN apt-get update && apt-get install -y net-tools
RUN apt-get update && apt-get install -y vim

RUN mkdir /var/run/sshd

RUN echo 'root:root' |chpasswd
RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -i '5a Port 10022' /etc/ssh/sshd_config

ADD ./scripts /home/scripts
WORKDIR /home/scripts/

ENTRYPOINT ["bash", "/home/scripts/autorun.sh"]
EXPOSE 10022
