FROM base/archlinux
MAINTAINER Kibeom Kim <kk1674@nyu.edu>

ENV HOME /root
WORKDIR /root
#RUN useradd kkimdev
#USER kkimdev

RUN echo -e \
  '#!/bin/bash \
  \n mkdir -p /tmp/"$1" && cd /tmp/"$1" \
  \n wget https://aur.archlinux.org/packages/"${1:0:2}"/"$1"/"$1".tar.gz \
  \n tar -xvf "$1".tar.gz \
  \n cd "$1" \
  \n makepkg -s --asroot --noconfirm \
  \n pacman -U --noconfirm "$1"-*.pkg.tar* \
  \n #rm -rf * \
  ' > aur_install.bash
RUN chmod +x aur_install.bash


# Sync repository
RUN pacman -Sy --noconfirm

# Install basic AUR tools.
RUN pacman -S --noconfirm --needed base-devel wget

# Install package-query
RUN pacman -S --noconfirm libunistring
RUN ./aur_install.bash package-query

# Install yaourt
RUN ./aur_install.bash yaourt

# Install rust
RUN ./aur_install.bash rust-nightly-bin

# Install cargo
RUN ./aur_install.bash cargo-nightly-bin

# final update
#RUN pacman -Syu --noconfirm












#docker run -i -t -v "$HOME":/opt/home -v /tmp:/tmp kkim/archlinux /bin/bash
