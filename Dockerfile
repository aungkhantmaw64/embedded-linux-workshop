FROM debian:12-slim

ARG CTNG_UID=1000
ARG CTNG_GID=1000

ENV DEBIAN_FRONTEND=noninteractive

RUN groupadd -g $CTNG_GID ctng
RUN useradd -d /opt/ctng -m -g $CTNG_GID -u $CTNG_UID -s /bin/bash ct-ng

RUN apt-get update && apt-get install -y git \
  gcc g++ gperf bison flex texinfo help2man make libncurses5-dev \
  python3-dev autoconf automake libtool libtool-bin gawk wget bzip2 xz-utils unzip \
  patch libstdc++6 rsync git meson ninja-build

WORKDIR /home

RUN git clone --depth 1 --branch crosstool-ng-1.26.0 https://github.com/crosstool-ng/crosstool-ng 

RUN cd /home/crosstool-ng/ && \
  ./bootstrap && \
  ./configure --prefix=/opt/ctng && \
  make && \
  make install

RUN git clone --depth 1 --branch v2024.07 https://github.com/u-boot/u-boot.git

ENV APP_PATH=/app

ENV PATH=${PATH}:/opt/ctng/bin

ENV CT_ALLOW_BUILD_AS_ROOT_SURE=1

WORKDIR /app

ADD .config /app/

RUN ct-ng build

