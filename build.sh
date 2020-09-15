#!/bin/bash

# docker build --build-arg OPENCV_VERSION="4.4.0" -t wildme/manylinux:opencv-4.4.0 .
docker build --build-arg OPENCV_VERSION="3.4.11" -t wildme/manylinux:opencv-3.4.11 .
docker tag wildme/manylinux:opencv-3.4.11 wildme/manylinux:latest

# docker tag wildme/manylinux:opencv-4.4.0 docker.pkg.github.com/wildbookorg/wbia-pypkg-build/manylinux:opencv-4.4.0
docker tag wildme/manylinux:opencv-3.4.11 docker.pkg.github.com/wildbookorg/wbia-pypkg-build/manylinux:opencv-3.4.11
docker tag wildme/manylinux:latest docker.pkg.github.com/wildbookorg/wbia-pypkg-build/manylinux:latest
