# This Dockerfile assembles a headless vnc image based on Scientific Linux 7

FROM scientificlinux/sl:7

MAINTAINER Pengfei Ding "dingpf@fnal.gov"
ENV REFRESHED_AT 2022-04-28


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
 perl-DBD-SQLite perl-ExtUtils-MakeMaker \
 gcc gcc-c++ libgcc.i686 glibc-devel.i686 libstdc++.i686 libffi-devel \
 && yum -y install nc perl expat-devel gdb time tar \
 zip xz bzip2 patch sudo gstreamer gtk2-devel xterm \
 openssh-clients rsync tmux svn sed cmake \
 gstreamer-plugins-base-devel  \
 vim which net-tools xorg-x11-fonts* \
 xorg-x11-server-utils xorg-x11-twm dbus dbus-x11 \
 libuuid-devel openssh-server evince eog emacs htop \
 libconfuse-devel xvfb nss_wrapper gettext unzip krb5-workstation \
 subversion-perl pcre2 redhat-lsb-core \
 && yum clean all
 
 RUN yum clean all \
 && yum install -y https://repo.opensciencegrid.org/osg/3.6/osg-3.6-el7-release-latest.rpm \
 && yum -y update \
 && yum --enablerepo=epel -y install osg-wn-client \
 && yum clean all

RUN wget -O /etc/krb5.conf https://authentication.fnal.gov/krb5conf/Linux/krb5.conf


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
