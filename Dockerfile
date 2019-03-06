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

# Set when building on Travis so that certain long-running build steps can
# be skipped to shorten build time.
ARG TEST_ONLY_BUILD



USER root

# Chrome and Firefox browsers
RUN apt-get update && \
	apt-get install -y clang clang-format gcc make nano



USER $NB_UID
