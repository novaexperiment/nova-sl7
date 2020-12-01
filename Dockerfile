# This Dockerfile is used to build an headles vnc image based on Centos

FROM scientificlinux/sl:7

MAINTAINER Pengfei Ding "dingpf@fnal.gov"
ENV REFRESHED_AT 2019-11-30

RUN yum clean all \
 && yum -y install epel-release \
 && yum -y update \
 && yum -y install yum-plugin-priorities \
 subversion asciidoc bzip2-devel \
 fontconfig-devel freetype-devel gdbm-devel glibc-devel \
 ncurses-devel openssl-devel openldap-devel readline-devel \
 autoconf automake libtool swig texinfo tcl-devel tk-devel \
 xz-devel xmlto zlib-devel libcurl-devel libjpeg-turbo-devel \
 libpng-devel libstdc++-devel libuuid-devel libX11-devel \
 libXext-devel libXft-devel libXi-devel libXrender-devel \
 libXt-devel libXpm-devel libXmu-devel mesa-libGL-devel \
 mesa-libGLU-devel perl-DBD-SQLite perl-ExtUtils-MakeMaker \
 gcc gcc-c++ libgcc.i686 glibc-devel.i686 libstdc++.i686 libffi-devel \
 && yum -y install yum-plugin-priorities \
 nc perl expat-devel gdb time tar zip xz bzip2 patch sudo which strace \
 openssh-clients rsync tmux svn git wget cmake \
 gcc gstreamer gtk2-devel xterm \
 gstreamer-plugins-base-devel  \
 vim which net-tools xorg-x11-fonts* \
 xorg-x11-server-utils xorg-x11-twm dbus dbus-x11 \
 libuuid-devel wget redhat-lsb-core openssh-server evince eog emacs \
  && yum clean all

RUN yum clean all \
 && yum --enablerepo=epel -y install htop osg-wn-client \
 libconfuse-devel xvfb nss_wrapper gettext unzip \
 subversion-perl \
 && yum clean all


ENV UPS_OVERRIDE="-H Linux64bit+3.10-2.17"

# Fix SSH Config
RUN echo -e '\tProtocol 2' >> /etc/ssh/ssh_config
RUN echo -e '\tGSSAPIDelegateCredentials yes' >> /etc/ssh/ssh_config
RUN echo -e '\tGSSAPIKeyExchange yes' >> /etc/ssh/ssh_config
RUN echo -e '\tForwardX11 yes' >> /etc/ssh/ssh_config
RUN echo    'Host 131.225.* *.fnal.gov *soudan.org' >> /etc/ssh/ssh_config
RUN echo -e '\tProtocol 2' >> /etc/ssh/ssh_config
RUN echo -e '\tGSSAPIAuthentication yes' >> /etc/ssh/ssh_config
RUN echo -e '\tGSSAPIDelegateCredentials yes' >> /etc/ssh/ssh_config
RUN echo -e '\tGSSAPIKeyExchange yes' >> /etc/ssh/ssh_config
RUN echo -e '\tForwardX11Trusted yes' >> /etc/ssh/ssh_config
RUN echo -e '\tForwardX11 yes' >> /etc/ssh/ssh_config


RUN dbus-uuidgen > /var/lib/dbus/machine-id

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

# Create a me user (UID and GID should match the Mac user), add to suoders, and switch to it
ENV USERNAME=me

ARG MYUID
ENV MYUID=${MYUID:-1000}
ARG MYGID
ENV MYGID=${MYGID:-100}

RUN useradd -u $MYUID -g $MYGID -ms /bin/bash $USERNAME && \
      echo "$USERNAME ALL=(ALL)   NOPASSWD:ALL" >> /etc/sudoers

USER $USERNAME


ENTRYPOINT ["/bin/bash"]
