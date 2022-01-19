# Build Ubuntu image with base functionality.
FROM ubuntu:focal AS ubuntu-base
ENV DEBIAN_FRONTEND noninteractive
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup the default user.
RUN useradd -rm -d /home/ssm -s /bin/bash -g root -G sudo ssm
RUN echo 'ssm:ssm' | chpasswd
USER ssm
WORKDIR /home/ssm

# Build image with Python and SSHD.
FROM ubuntu-base AS ubuntu-with-sshd
USER root

# Install required tools.
RUN apt-get -qq update \
    && apt-get -qq --no-install-recommends install vim-tiny=2:8.1.* \
    && apt-get -qq --no-install-recommends install sudo=1.8.* \
    && apt-get -qq --no-install-recommends install python3-pip=20.0.* \
    && apt-get -qq --no-install-recommends install openssh-server=1:8.* \
    && apt-get -qq clean    \
    && rm -rf /var/lib/apt/lists/*

# Configure SSHD.
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN mkdir /var/run/sshd
RUN bash -c 'install -m755 <(printf "#!/bin/sh\nexit 0") /usr/sbin/policy-rc.d'
RUN ex +'%s/^#\zeListenAddress/\1/g' -scwq /etc/ssh/sshd_config
RUN ex +'%s/^#\zeHostKey .*ssh_host_.*_key/\1/g' -scwq /etc/ssh/sshd_config
RUN sed -i "s/^#.*IdentityFile ~\/.ssh\/id_rsa/IdentityFile ~\/.ssh\/id_rsa/g" /etc/ssh/ssh_config
RUN RUNLEVEL=1 dpkg-reconfigure openssh-server
RUN ssh-keygen -A -v
RUN update-rc.d ssh defaults

# Configure sudo.
RUN ex +"%s/^%sudo.*$/%sudo ALL=(ALL:ALL) NOPASSWD:ALL/g" -scwq! /etc/sudoers

# Generate and configure user keys.
USER ssm
# RUN ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519

# Setup default command and/or parameters.
EXPOSE 22
#Install AWS utilz
COPY entrypoint.sh /entrypoint.sh
RUN sudo chmod +x /entrypoint.sh
RUN sudo apt-get update
RUN sudo apt-get -qq install curl unzip iproute2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb" \
    && unzip awscliv2.zip \
    && sudo ./aws/install \
    && sudo dpkg -i session-manager-plugin.deb \
    && sudo pip3 install aws-ssm-tools \
    && aws --version \
    && session-manager-plugin --version


ENTRYPOINT [ "/entrypoint.sh" ]
