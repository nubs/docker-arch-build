FROM base/devel:minimal

MAINTAINER Spencer Rinehart <anubis@overthemonkey.com>

RUN pacman --sync --refresh --sysupgrade --noconfirm --noprogressbar --quiet && pacman --sync --noconfirm --noprogressbar --quiet git namcap

RUN useradd --create-home --comment "Arch Build User" build

USER build
ENV HOME /home/build
WORKDIR /home/build

RUN curl -sS https://aur.archlinux.org/packages/pk/pkgbuild-introspection-git/pkgbuild-introspection-git.tar.gz | tar -xz
RUN cd pkgbuild-introspection-git && makepkg --clean --noconfirm --noprogressbar

USER root
RUN pacman --upgrade --noconfirm --noprogressbar pkgbuild-introspection-git/pkgbuild-introspection-git*.pkg.tar.xz

RUN mkdir /package
RUN chown build /package
VOLUME ["/package"]
WORKDIR /package

USER build

CMD ["makepkg", "--force"]
