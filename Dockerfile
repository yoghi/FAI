# sshd
#
# VERSION               0.0.1

FROM debian:jessie
MAINTAINER Stefano Tamagnini <yoghi@sigmalab.net>

RUN apt-get update && apt-get install locales
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen && locale -a
RUN apt-get install -y less vim nano htop curl rsync screen openssh-server python
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22 25 80 443 587 993 1194 1936
CMD ["/usr/sbin/sshd", "-D"]
