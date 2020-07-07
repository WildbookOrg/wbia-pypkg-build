#!/bin/bash

docker build --build-arg OPENCV_VERSION="4.2.0" -t wildme/manylinux:opencv-4.2.0 .
docker build --build-arg OPENCV_VERSION="3.4.10" -t wildme/manylinux:opencv-3.4.10 .
docker tag wildme/manylinux:opencv-4.2.0 wildme/manylinux:latest

docker tag wildme/manylinux:opencv-4.2.0 docker.pkg.github.com/wbia-pypkg-build/manylinux:opencv-4.2.0
docker tag wildme/manylinux:opencv-3.4.10 docker.pkg.github.com/wbia-pypkg-build/manylinux:opencv-3.4.10
docker tag wildme/manylinux:latest docker.pkg.github.com/wbia-pypkg-build/manylinux:latest
