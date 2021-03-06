# docker-arch-build
This is a base image for building packages for [Arch Linux].

## Purpose
This docker image builds on top of Arch Linux's base/devel image for the
purpose of building arch packages.  It provides several key features:

* A non-root user (`build`) for executing the image build.  This is important
  to ensure that the package can be built correctly without destructively
  modifying the system.
* The [pkgbuild-introspection] library including the `mksrcinfo` and
  `mkaurball`  commands.  This makes it easy to generate the `.SRCINFO`
  files to upload to AUR for your packages.
* The [namcap] command is included to help validate your `PKGBUILD`'s.
* Default docker command of `makepkg --force`.  This is a common usecase:
  needing to build the package for testing.
* Access to the build location will be in the volume located at `/package`.

## Usage
This library is useful with simple `PKGBUILD`'s from the command line.  For
example, assuming you have a `PKGBUILD` with no additional dependencies beyond
`base-devel` in `/tmp/my-package`:

```bash
docker run --interactive --tty --rm --volume /tmp/my-package:/package nubs/arch-build

# Using short-options:
# docker run -i -t --rm -v /tmp/my-package:/package nubs/arch-build
```

This will make the package placing the results (including the `pkg.tar.xz`
file for a successful build) in `/tmp/my-package`.

In order to create the `.SRCINFO`:

```bash
docker run -i -t --rm -v /tmp/my-package:/package nubs/arch-build mksrcinfo
```

### Dockerfile build
Alternatively, you can create your own `Dockerfile` that builds on top of this
image.  This allows you to modify the environment by installing additional
software needed, altering the commands to run, etc.

A simple one that just installs another package but leaves the rest of the
process alone could look like this:

```dockerfile
FROM nubs/arch-build

USER root

RUN pacman --sync --noconfirm --noprogressbar --quiet php

USER build
```

You can then build this docker image and run it against your `PKGBUILD` volume
like normal (this example assumes the `PKGBUILD` and `Dockerfile` are in your
current directory):

```bash
docker build --tag my-package .
docker run -i -t --rm -v "$(pwd):/package" my-package
docker run -i -t --rm -v "$(pwd):/package" my-package mksrcinfo
```

## Permissions
Because the container runs as a non-root user, you may run into permission
problems when using volume mounts to your host.  The build user used in the
container is uid/gid 1000, so you may need to provide write access to that
user to any files/directories that need to be written to.  For example:

```bash
chgrp 1000 .
chmod g+w .
```

## License
docker-arch-build is licensed under the MIT license.  See [LICENSE] for the
full license text.

[Arch Linux]: https://www.archlinux.org/
[pkgbuild-introspection]: https://github.com/falconindy/pkgbuild-introspection
[namcap]: https://wiki.archlinux.org/index.php/Namcap
[LICENSE]: https://github.com/nubs/docker-arch-build/blob/master/LICENSE
