FROM ubuntu:trusty
RUN apt-get update -y
# Build environment.
RUN apt-get install -y \
	    build-essential \
	    ccache \
	    wget \
	    ;
# For AppImage support.
RUN apt-get install -y \
	    fuse \
	    libfuse2 \
	    ;
# For building wmctrl.
RUN apt-get install -y \
	    libglib2.0-dev \
	    libx11-dev \
	    libxmu-dev \
	    ;
# For building Python 3.5.
RUN apt-get install -y \
	    libbz2-dev \
	    libgdbm-dev \
	    liblzma-dev \
	    libncurses5-dev \
	    libreadline-dev \
	    libsqlite3-dev \
	    libssl-dev \
	    zlib1g-dev \
	    ;
# For building cython-hidapi.
RUN apt-get install -y \
	    libudev-dev \
	    libusb-1.0-0-dev \
	    ;
# For building dbus-python.
RUN apt-get install -y \
	    libdbus-1-dev \
	    libdbus-glib-1-dev \
	    ;
# For PyQt5.
RUN apt-get install -y \
	    libgl1-mesa-glx \
	    ;
