FROM ubuntu:trusty

# Installation helper.
RUN printf '#!/bin/sh\n export DEBIAN_FRONTEND=noninteractive; set -x; apt-get update -qqy && apt-get dist-upgrade -qqy --verbose-versions && apt-get install -qqy --verbose-versions "$@"' >install.sh && chmod +x install.sh

# Install build essentials.
RUN ./install.sh \
	    build-essential \
	    ccache \
	    wget \
	    ;

# Install AppImage tools dependencies.
RUN ./install.sh \
	    fuse \
	    libfuse2 \
	    ;

# Install Python build dependencies.
RUN ./install.sh \
	    libbz2-dev \
	    libdb5.3-dev \
	    libffi-dev \
	    libgdbm-dev \
	    liblzma-dev \
	    libncurses5-dev \
	    libreadline-dev \
	    libsqlite3-dev \
	    libssl-dev \
	    uuid-dev \
	    zlib1g-dev \
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

# Install PyQt5 dependencies.
RUN ./install.sh \
	    libasound2 \
	    libegl1-mesa \
	    libfontconfig1 \
	    libgl1-mesa-glx \
	    libnss3 \
	    libxcomposite1 \
	    libxcursor1 \
	    libxi6 \
	    libxrandr2 \
	    libxss1 \
	    libxtst6 \
	    ;

# Install newer binutils/gcc/g++ toolchain.
RUN ./install.sh binutils-2.26
ENV PATH "/usr/lib/binutils-2.26/bin:$PATH"
RUN ld --version
RUN ./install.sh software-properties-common
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test
RUN apt-get remove -y software-properties-common
RUN apt-get autoremove -y
RUN ./install.sh gcc-8 g++-8
ENV GCC8BIN="/usr/lib/gcc-8/bin"
ENV PATH "$GCC8BIN:$PATH"
RUN \
	    mkdir "$GCC8BIN" -p && \
	    for tool in g++ gcc gcov-dump gcov-tool gcov; \
	    do \
		    ln -s "../../../bin/$tool-8" "$GCC8BIN/$tool"; \
		    $tool --version; \
	    done \
	    ;

# Install Python 3.6.
ENV PYTHON_VERSION 3.6.8
RUN wget --quiet "https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz"
RUN tar xJf Python-$PYTHON_VERSION.tar.xz
WORKDIR "Python-$PYTHON_VERSION"
RUN CFLAGS="-O3" ./configure \
	    --enable-ipv6 \
	    --enable-loadable-sqlite-extensions \
	    --enable-optimizations \
	    --enable-shared \
	    --with-computed-gotos \
	    --with-openssl=/usr/local \
	    --without-ensurepip \
	    --without-lto \
	    ;
RUN make -j2
RUN make test
RUN make install
WORKDIR ..
RUN rm -rf "Python-$PYTHON_VERSION"
RUN ldconfig
RUN python3 --version

# Install Plover build dependencies.
RUN wget --quiet https://bootstrap.pypa.io/get-pip.py
RUN python3 get-pip.py --no-cache-dir
RUN rm get-pip.py
RUN python3 -m pip --no-cache-dir install -U Cython Babel PyQt5
RUN python3 -m pip --no-cache-dir freeze --all

# Cleanup after ourselves...
RUN rm install.sh
RUN apt-get clean
