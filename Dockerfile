FROM base/devel:minimal

MAINTAINER Spencer Rinehart <anubis@overthemonkey.com>

RUN pacman --sync --refresh --noconfirm --noprogressbar --quiet
RUN pacman --sync --noconfirm --noprogressbar --quiet git

RUN useradd --create-home --comment "Arch Build User" build
RUN echo "build ALL=(ALL:ALL) NOPASSWD: ALL" >>/etc/sudoers

USER build
ENV HOME /home/build
WORKDIR /home/build

RUN curl -sS https://aur.archlinux.org/packages/pk/pkgbuild-introspection-git/pkgbuild-introspection-git.tar.gz | tar -xz
RUN cd pkgbuild-introspection-git && makepkg --clean --install --noconfirm --noprogressbar

VOLUME ["/package"]
WORKDIR /package

CMD ["makepkg", "--force"]
