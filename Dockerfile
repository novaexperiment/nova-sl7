# This Dockerfile is used to build an headles vnc image based on Centos

FROM scientificlinux/sl:7

MAINTAINER Pengfei Ding "dingpf@fnal.gov"
ENV REFRESHED_AT 2019-11-30

RUN yum clean all \
 && yum -y install epel-release \
 && yum -y update \
 && yum -y install yum-plugin-priorities \
 subversion asciidoc bzip2-devel \
 fontconfig-devel freetype-devel gdbm-devel  \
 ncurses-devel openssl-devel openldap-devel readline-devel \
 autoconf automake libtool swig texinfo tcl-devel tk-devel \
 xz-devel xmlto zlib-devel libcurl-devel libjpeg-turbo-devel \
 libpng-devel libstdc++-devel libuuid-devel libX11-devel \
 libXext-devel libXft-devel libXi-devel libXrender-devel \
 libXt-devel libXpm-devel libXmu-devel mesa-libGL-devel \
 mesa-libGLU-devel perl-DBD-SQLite perl-ExtUtils-MakeMaker \
 gcc gcc-c++ libgcc.i686 libstdc++.i686 libffi-devel \
 && yum -y install yum-plugin-priorities \
 nc perl expat-devel gdb time tar zip xz bzip2 patch sudo which strace \
 openssh-clients rsync tmux svn git wget cmake \
 gcc gstreamer gtk2-devel xterm \
 gstreamer-plugins-base-devel  \
 vim which net-tools xorg-x11-fonts* \
 xorg-x11-server-utils xorg-x11-twm dbus dbus-x11 \
 libuuid-devel wget redhat-lsb-core openssh-server evince eog emacs \
 gnuplot pcre2 \
 parallel \
  && yum clean all

RUN yum clean all \
 && yum install -y https://repo.opensciencegrid.org/osg/3.6/osg-3.6-el7-release-latest.rpm \
 && yum -y update \
 && yum --enablerepo=epel -y install htop osg-wn-client \
 libconfuse-devel xvfb nss_wrapper gettext unzip krb5-workstation \
 subversion-perl \
 && yum clean all

RUN wget -nv https://authentication.fnal.gov/krb5conf/Linux/krb5.conf -O /etc/krb5.conf

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

# vim configuration
#RUN alias vi=vim
RUN echo -e "alias vi=vim" >> ~/.bashrc
RUN echo -e "set tabstop=2" >> ~/.vimrc
RUN echo -e "set shiftwidth=2" >> ~/.vimrc
RUN echo -e "set expandtab" >> ~/.vimrc
RUN echo -e "set visualbell" >> ~/.vimrc
RUN echo -e "set t_vb=" >> ~/.vimrc
RUN echo -e "let g:loaded_matchparen=1" >> ~/.vimrc
RUN echo -e "syntax on" >> ~/.vimrc

RUN dbus-uuidgen > /var/lib/dbus/machine-id

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

# **** install bison (needed when compiling glibc) **** 

RUN yum clean all \
  && yum install -y bison \
  && yum clean all

# **** add gcc and python UPS product ****
RUN mkdir /products \
  && cd /products \
  && wget -nv https://github.com/DUNE-DAQ/daq-release/raw/develop/misc/ups-products-area.tar.bz2 \
  && tar xf  ups-products-area.tar.bz2 \
  && wget -nv https://scisoft.fnal.gov/scisoft/packages/gcc/v8_2_0/gcc-8.2.0-sl7-x86_64.tar.bz2 \
  && wget -nv https://scisoft.fnal.gov/scisoft/packages/python/v3_8_3b/python-3.8.3b-sl7-x86_64.tar.bz2 \
  && wget -nv https://scisoft.fnal.gov/scisoft/packages/sqlite/v3_32_03_00/sqlite-3.32.03.00-sl7-x86_64.tar.bz2 \
  && tar xf gcc-8.2.0-sl7-x86_64.tar.bz2 \
  && tar xf python-3.8.3b-sl7-x86_64.tar.bz2 \
  && tar xf sqlite-3.32.03.00-sl7-x86_64.tar.bz2 \
  && rm -rf *.bz2 

# **** install GNU make 4.2 (needed by glibc 2.35) ****
RUN cd /root \
  &&  wget -nv https://ftp.gnu.org/gnu/make/make-4.2.tar.gz \
  && tar xvf make-4.2.tar.gz \
  &&  cd make-4.2 \
  && source /products/setup \
  && setup gcc v8_2_0 \
  && ./configure \
  && make -j 16 \
  && make install \
  && rm -f /usr/bin/make \
  && ln -s /usr/local/bin/make /usr/bin/make

# **** install glibc ****
RUN cd /root \
  && wget -nv https://ftp.gnu.org/gnu/glibc/glibc-2.34.tar.gz \
  && tar xf glibc-2.34.tar.gz \
  && cd glibc-2.34 \
  && mkdir build \
  && cd build \
  && source /products/setup \
  && setup gcc v8_2_0 \
  && setup python v3_8_3b \
  && ../configure --prefix=/opt/glibc \
  && echo $LD_LIBRARY_PATH \
  && make -j 16 \
  && make install

# **** install mpich ****
RUN mkdir /mpich \
  && mkdir /build \
  && cd /build \
  && wget -nv http://www.mpich.org/static/downloads/3.4.1/mpich-3.4.1.tar.gz \
  && tar xf mpich-3.4.1.tar.gz \
  && cd mpich-3.4.1 \
  && source /products/setup \
  && setup gcc v8_2_0 \
  && ./configure LDFLAGS="-Wl,--rpath=/opt/glibc/lib \
    -Wl,--dynamic-linker=/opt/glibc/lib/ld-linux-x86-64.so.2" \
    --disable-fortran --with-device=ch3 -prefix /mpich \
  && make -j4 \
  && make \
  && make install \
  && make clean \
  && rm -rf /build
ENV PATH=$PATH:/mpich/bin
ENV LD_LIBRARY_PATH=/mpich/lib

# **** Add diy ****
RUN git clone https://github.com/diatomic/diy /usr/local/diy \
#  && cd /usr/local/diy && git checkout 3.5.0 \
  && cd /usr/local/diy \
  && rm -rf /usr/local/diy/.git


ENTRYPOINT ["/bin/bash"]
