FROM archlinux:base-devel

MAINTAINER Spencer Rinehart <anubis@overthemonkey.com>

RUN pacman --sync --refresh --sysupgrade --noconfirm --noprogressbar --quiet && \
  pacman --sync --noconfirm --noprogressbar --quiet git namcap

RUN useradd --create-home --comment "Arch Build User" build
ENV HOME /home/build

RUN mkdir /package
RUN chown build /package
WORKDIR /package

USER build

CMD ["makepkg", "--force"]
