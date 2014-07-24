FROM base/devel:minimal

MAINTAINER Spencer Rinehart <anubis@overthemonkey.com>

RUN pacman --sync --refresh --sysupgrade --ignore filesystem --noconfirm --noprogressbar --quiet
RUN pacman --sync --noconfirm --noprogressbar --quiet git

RUN useradd --create-home --comment "Arch Build User" build

USER build
ENV HOME /home/build
WORKDIR /home/build

RUN curl -sS https://aur.archlinux.org/packages/pk/pkgbuild-introspection-git/pkgbuild-introspection-git.tar.gz | tar -xz
RUN cd pkgbuild-introspection-git && makepkg --clean --noconfirm --noprogressbar

USER root
RUN pacman --upgrade --noconfirm --noprogressbar pkgbuild-introspection-git/pkgbuild-introspection-git*.pkg.tar.xz

USER build

VOLUME ["/package"]
WORKDIR /package

CMD ["makepkg", "--force"]
