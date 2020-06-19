# Wildbook IA - manylinux container

This repository contains instructions for the creating a base container used in the building of Wildbook IA (wbia) Python libraries.

This work derives from the [Many Linux project's base](https://github.com/pypa/manylinux). We add OpenCV2 into the project as it is a dependency that many of our libraries require.

## Usage

This is intended to be used the same as any `manylinux` container.

We use the [cibuildwheel](https://github.com/joerick/cibuildwheel) tool, which abstracts the building of wheels. To use this image with the tool set the `CIBW_MANYLINUX_X86_64_IMAGE` environment variable to this image.

    export CIBW_MANYLINUX_X86_64_IMAGE=wildme/wbia-manylinux

## Installed build tools

This container includes an installation of OpenCV 4.2.0 with contrib modules.

This container is build on [The Many Linux Project's](https://github.com/pypa/manylinux) 2010 x86_64 container. This therefore will produce wheels tagged with `manylinux2010_x86_64`.

Python 3.6 installed libraries

* cmake
* ninja
* scikit-build
* wheel
* numpy

## License

This software is subject to the provisions of the Apache License 2.0 (APL 2.0). See LICENSE file for details. Copyright (c) 2020 Wild Me.
