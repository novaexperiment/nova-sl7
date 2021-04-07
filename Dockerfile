# This Dockerfile is used to build an headles vnc image based on Centos

FROM fermilab/fnal-wn-sl7

MAINTAINER Pengfei Ding "dingpf@fnal.gov"
ENV REFRESHED_AT 2020-04-07

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
