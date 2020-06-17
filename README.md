# The WildBook IA (WBIA) Python Package Build base container

## Project Description

This is a container built on Ubuntu 18.04 with Python 3.6 and OpenCV 3.4.4 installed. The goal for this container is to be able to build libraries to binary format for use by the application.

This only supports building against Python 3.6 and OpenCV 3.4.4.

## Requirements

This only requires that you have Docker or some other container engine installed on your system. Note, the documenation here specifically use Docker.


## Usage

Build the container:

    docker build -t wildme/wbia-pypkg-build:dev .

Run it over your code, for example:

    git clone https://github.com/WildbookOrg/wbia-tpl-pydarknet.git
    cd wbia-tpl-pydarknet
    docker run --rm -v $PWD:/code -w /code wildme/wbia-pypkg-build:dev ...
    

## License

This software is subject to the provisions of the Apache License 2.0. See LICENSE file for details. Copyright (c) 2020 WildMe.
