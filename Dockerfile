FROM archlinux:base-devel as base

RUN pacman --sync --refresh --sysupgrade --noconfirm --noprogressbar --quiet
RUN pacman --sync --noconfirm --noprogressbar --quiet git namcap
RUN yes | pacman --sync --clean --clean

RUN useradd --create-home --comment "Arch Build User" build

RUN mkdir /package
RUN chown build /package

FROM scratch as syncdeps

ENV LANG en_US.UTF-8
ENV HOME /home/build

WORKDIR /package

COPY --from=base / /

RUN usermod -aG wheel build
RUN echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

USER build

CMD ["makepkg", "--force", "--syncdeps"]

FROM scratch

MAINTAINER Spencer Rinehart <anubis@overthemonkey.com>

ENV LANG en_US.UTF-8
ENV HOME /home/build

WORKDIR /package

USER build

COPY --from=base / /

CMD ["makepkg", "--force"]
