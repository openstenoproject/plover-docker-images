FROM base/archlinux:latest
RUN pacman --sync --refresh --sysupgrade
RUN pacman -S --needed --noconfirm base-devel
RUN echo '%adm ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers
# Plover dependencies.
RUN pacman -S --needed --noconfirm \
	    python \
	    python-appdirs \
	    python-babel \
	    python-dbus \
	    python-hidapi \
	    python-mock \
	    python-pyqt5 \
	    python-pyserial \
	    python-pytest \
	    python-setuptools \
	    python-setuptools-scm \
	    python-six \
	    python-xlib \
	    wmctrl \
	    ;
