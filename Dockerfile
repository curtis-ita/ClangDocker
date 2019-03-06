# Copyright (c) 2018, Instituto Tecnológico de Aeronáutica - Divisão de Ciência da Computação
#
# All rights reserved.
# Distributed under the terms of the Modified BSD License (BSD 3-Clause License).
#

FROM ubuntu

LABEL maintainer="Vitor Curtis <curtis@ita.br>"
ARG NB_USER="jovyan"
ARG NB_UID="1000"
ARG NB_GID="100"



USER root

# Install all OS dependencies for notebook server that starts but lacks all
# features (e.g., download as all possible file formats)
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -yq dist-upgrade \
 && apt-get install -yq --no-install-recommends \
    wget \
    bzip2 \
    ca-certificates \
    sudo \
    locales \
    fonts-liberation \
 && rm -rf /var/lib/apt/lists/*

# local
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
locale-gen
	
# Configure environment
ENV SHELL=/bin/bash \
    NB_USER=$NB_USER \
    NB_UID=$NB_UID \
    NB_GID=$NB_GID \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8
ENV HOME=/home/$NB_USER

ADD fix-permissions /usr/local/bin/fix-permissions
RUN chmod a+x /usr/local/bin/fix-permissions
# Create jovyan user with UID=1000 and in the 'users' group
# and make sure these dirs are writable by the `users` group.
RUN groupadd wheel -g 11
RUN echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su
RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER
RUN chmod g+w /etc/passwd
RUN fix-permissions $HOME



USER $NB_UID

# Setup work directory for backward-compatibility
RUN mkdir /home/$NB_USER/work
RUN fix-permissions /home/$NB_USER



USER root

WORKDIR $HOME

# Install compilers
RUN apt-get update && \
	apt-get install -y clang clang-format gcc make nano



# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID
