# Tmux
#
# VERSION 0.0.1

FROM ubuntu:trusty

MAINTAINER Bruno Sutic "bruno.sutic@gmail.com"

RUN apt-get update

RUN apt-get install -y git-core
RUN apt-get install -y expect
RUN apt-get install -y python-software-properties software-properties-common

# sshd
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd

# Enabling passwordless ssh login with `docker_ssh.key` private key.
RUN mkdir -p /root/.ssh/
RUN echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDVmzBG5v7cO9IScGLIzlhGlHNFhXzy87VfaPzru7qnIIdQ1e9FEKvtqEws8hVixnCUdviwX5lvcMk4Ef4Tbrmj3dyF0zFtYbjiTSyl/XQlF68DQlc2sTAdHy96wJHvh7ky511tKJzzyWwSqeef4WjeVK28TqcGnq1up0S7saFO0dJh6OfDAg2cDmhyweR3VgT0vZJyrDV7hte95MBCdK+Gp7fdCyEZcWm3S1DBFaeBqHzzt/Y/njAVKbYL9TIVPum8iMg0rMiLi9ShfP+dT5Xud5Oa3dcN2OWhiDfJw5pfhFJWd44cJ/uGRwQpvNs/PNKsYABhgLlTMUH4iawhu1Xb' > /root/.ssh/authorized_keys

# install latest Tmux 1.9a
RUN add-apt-repository ppa:pi-rho/dev
RUN apt-get update
RUN apt-get install -y tmux=1.9a-1~ppa1~t

EXPOSE 22
CMD /usr/sbin/sshd -D
