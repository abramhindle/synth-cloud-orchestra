# chef base
FROM ubuntussh:14.04

MAINTAINER Abram Hindle <hindle1@ualberta.ca>

ENV LANG "en_US.UTF-8"

ENV LOGNAME docker

RUN mkdir /var/run/sshd
RUN echo 'root:chefbase' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile


EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
