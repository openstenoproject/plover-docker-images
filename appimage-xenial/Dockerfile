FROM ubuntu:xenial as base

# Tweak shell.
SHELL ["/bin/bash", "-c"]

# Installation helper.
RUN printf '#!/bin/sh\n\
export DEBIAN_FRONTEND=noninteractive; \
set -x; \
apt-get update -qq && \
if [ "x$1" = "x--repo" ]; \
then \
  "$0" software-properties-common && \
  apt-add-repository -y "$2" && \
  apt-get -qq update && \
  apt-get -qq remove --auto-remove software-properties-common && \
  shift 2; \
fi && \
if [ -z "$1" ]; \
then \
  apt-get -qq dist-upgrade --no-install-recommends --verbose-versions; \
else \
  apt-get -qq install --no-install-recommends --verbose-versions "$@"; \
fi; \
code=$?; \
apt-get -qq clean; \
exit $code\n\
' >install.sh && chmod +x install.sh

# Update.
RUN ./install.sh

# Install some essentials...
RUN ./install.sh \
      apt-utils \
      make \
      patch \
      wget \
      xz-utils \
      ;

# Install a more recent toolchain.
RUN ./install.sh --repo ppa:ubuntu-toolchain-r/test gcc-8 g++-8
RUN for tool in g++ gcc gcov-dump gcov-tool gcov; \
    do \
      ln -s "../../bin/$tool-8" "/usr/local/bin/$tool"; \
      $tool --version; \
    done

# Install OpenSSL dependencies.
RUN ./install.sh \
      libkrb5-3 \
      libsctp1 \
      zlib1g \
      ;

# Install Python dependencies.
RUN ./install.sh \
      libbz2-1.0 \
      libdb5.3 \
      libffi6 \
      libgdbm3 \
      liblzma5 \
      libncurses5 \
      libreadline6 \
      libsqlite3-0 \
      libuuid1 \
      zlib1g \
      ;

FROM base AS python_install

# Install OpenSSL build dependencies.
RUN ./install.sh \
      perl \
      libkrb5-dev \
      libsctp-dev \
      zlib1g-dev \
      ;

# Install a more recent version of OpenSSL.
ARG OPENSSL_VERSION="1.1.1f"
RUN wget "https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz"
RUN tar xzf "openssl-$OPENSSL_VERSION.tar.gz"
WORKDIR "openssl-$OPENSSL_VERSION"
RUN ./Configure \
      --openssldir=/etc/ssl \
      shared no-ssl3-method enable-ec_nistp_64_gcc_128 linux-x86_64 \
      "-Wa,--noexecstack -Wall" \
      && perl configdata.pm -d
RUN make -j2
RUN make test
RUN make install_sw
WORKDIR ..
RUN rm -rf "openssl-$OPENSSL_VERSION"*
RUN ldconfig
# Work around the braindead SSL detection code in Python...
RUN mkdir /usr/local/ssl && \
      ln -s ../include /usr/local/ssl/include && \
      ln -s ../lib64 /usr/local/ssl/lib

# Install Python build dependencies.
RUN ./install.sh \
      libbz2-dev \
      libdb5.3-dev \
      libffi-dev \
      libgdbm-dev \
      liblzma-dev \
      libncurses5-dev \
      libreadline6-dev \
      libsqlite3-dev \
      netbase \
      uuid-dev \
      zlib1g-dev \
      ;

# Install Python.
ARG PYTHON_VERSION="3.6.10"
RUN wget --quiet "https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz"
RUN tar xJf Python-$PYTHON_VERSION.tar.xz
WORKDIR "Python-$PYTHON_VERSION"
ARG PYTHON_REPO="https://github.com/python/cpython"
ARG PYTHON_PATCHES="\
"
RUN eval patches=("$PYTHON_REPO/commit"/{${PYTHON_PATCHES%,}}.patch); wget --quiet -O - "${patches[@]}" | patch -p1
ARG PYTHON_CONFIG="\
--enable-ipv6 \
--enable-loadable-sqlite-extensions \
--enable-optimizations \
--enable-shared \
--with-computed-gotos \
--with-lto \
--without-ensurepip \
"
RUN ./configure $PYTHON_CONFIG
RUN make -j2
RUN make test
RUN make install
WORKDIR ..
RUN rm -rf "Python-$PYTHON_VERSION"*
RUN ldconfig
RUN python3 --version

FROM base
COPY --from=python_install /usr/local /usr/local/
RUN ldconfig

# Install AppImage tools dependencies.
RUN ./install.sh \
      file \
      libp11-kit0 \
      ;

# Install cython-hidapi build dependencies.
RUN ./install.sh \
      libudev-dev \
      libusb-1.0-0-dev \
      ;

# Install dbus-python build dependencies.
RUN ./install.sh \
      libdbus-1-dev \
      libdbus-glib-1-dev \
      ;

# Install PyQt5 (minimal) dependencies.
RUN ./install.sh \
      libasound2 \
      libegl1-mesa \
      libfontconfig1 \
      libfreetype6 \
      libgl1-mesa-glx \
      libnss3 \
      libxcomposite1 \
      libxcursor1 \
      libxi6 \
      libxrandr2 \
      libxtst6 \
      ;

# Install pip and Plover build dependencies.
RUN wget --quiet -O - https://bootstrap.pypa.io/get-pip.py | python3 - \
      --no-cache-dir \
      Cython \
      Babel \
      PyQt5 \
      ;
RUN python3 -m pip --no-cache-dir freeze --all

# vim: sw=2
