# chef base
FROM ubuntussh:14.04

MAINTAINER Abram Hindle <hindle1@ualberta.ca>

ENV LANG "en_US.UTF-8"

ENV LOGNAME docker

RUN apt-get install -y ruby1.9.1 ruby1.9.1-dev make


RUN mkdir /var/run/sshd
RUN echo 'root:chefbase' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# add ubuntu user
RUN useradd -m ubuntu
RUN sudo usermod -a -G sudo ubuntu
RUN echo "ubuntu:ubuntu"|chpasswd
RUN echo "ubuntu ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
# Why this song and dance? So that AUFS doesn't bite. Thanks.
ADD id_rsa.pub /tmp/
RUN chmod 644 /tmp/id_rsa.pub && chown ubuntu.ubuntu /tmp/id_rsa.pub
RUN mkdir -p /home/ubuntu/.ssh/ && chown ubuntu.ubuntu /home/ubuntu/.ssh/ && chmod 700 /home/ubuntu/.ssh && cp /tmp/id_rsa.pub /home/ubuntu/.ssh/authorized_keys && chmod 600 /home/ubuntu/.ssh/authorized_keys && chown ubuntu.ubuntu /home/ubuntu/.ssh/authorized_keys

RUN apt-get install -y git chef chef-zero 

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
