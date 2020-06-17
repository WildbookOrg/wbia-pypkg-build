FROM nvidia/cuda:9.2-cudnn7-devel-ubuntu18.04

MAINTAINER Wild Me <dev@wildme.org>

ARG OPENCV_VERSION=3.4.10
ARG NUMPY_VERSION=1.18.5

# Fix for ubuntu 18.04 container https://stackoverflow.com/a/58173981/176882
ENV LANG C.UTF-8

USER root


# ###
# System setup
# ###

# Install system dependencies
RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
       # Dependencies needed for building OpenCV
       #     ** Please sort alphabetically **
       build-essential \
       git \
       pkg-config \
       libgtk-3-dev \
       libavcodec-dev \
       libavformat-dev \
       libswscale-dev \
       libv4l-dev \
       libxvidcore-dev \
       libx264-dev \
       libjpeg-dev \
       libpng-dev \
       libtiff-dev \
       gfortran \
       openexr \
       libatlas-base-dev \
       python3-dev \
       libtbb2 \
       libtbb-dev \
       libdc1394-22-dev \
       # Other dependencies either needed for pkg building
       #     ** Please sort alphabetically **
       ca-certificates \
       python3-gdbm \
       python3-pip \
       python3-pkg-resources \
       python3-setuptools \
       python3-venv \
       unzip \
    && rm -rf /var/lib/apt/lists/*


# ###
# Build dependencies setup
# ###

# Build dependencies
RUN python3 -m pip install \
    # The system installed cmake is sometimes too old
    # for builds that use this container,
    # so we'll use the newest available version.
    cmake \
    numpy==$NUMPY_VERSION \
    scikit-build

# Install OpenCV
RUN set -x \
 && git clone https://github.com/opencv/opencv.git /tmp/opencv \
 && git clone https://github.com/opencv/opencv_contrib.git /tmp/opencv_contrib \
 && cd /tmp/opencv \
 && git checkout $OPENCV_VERSION \
 && cd /tmp/opencv_contrib \
 && git checkout $OPENCV_VERSION \
 && rm -rf /tmp/opencv/build \
 && mkdir -p /tmp/opencv/build \
 && cd /tmp/opencv/build \
 && cmake \
     -D CMAKE_C_COMPILER=gcc \
     -D CMAKE_CXX_COMPILER=g++ \
     -D CMAKE_BUILD_TYPE=RELEASE \
     -D CMAKE_INSTALL_PREFIX=/usr/local \
     -D OPENCV_GENERATE_PKGCONFIG=ON \
     -D ENABLE_PRECOMPILED_HEADERS=OFF \
     -D BUILD_DOCS=OFF \
     -D BUILD_EXAMPLES=ON \
     -D BUILD_opencv_java=OFF \
     -D BUILD_opencv_python3=ON \
     -D BUILD_NEW_PYTHON_SUPPORT=ON \
     -D INSTALL_C_EXAMPLES=OFF \
     -D INSTALL_PYTHON_EXAMPLES=ON \
     -D BUILD_JPEG=ON \
     -D BUILD_HDR=ON \
     -D WITH_MATLAB=OFF \
     -D WITH_TBB=ON \
     -D WITH_CUDA=ON \
     -D WITH_CUBLAS=1 \
     -D WITH_EIGEN=ON \
     -D WITH_AVFOUNDATION=ON \
     -D WITH_JPEG=ON \
     -D WITH_HDR=ON \
     -D WITH_V4L=ON \
     -D WITH_GDAL=ON \
     -D PYTHON_EXECUTABLE=/usr/bin/python3 \
     -D PYTHON_INCLUDE_DIR=/usr/include/python3.6m \
     -D PYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython3.6m.so \
     -D PYTHON_PACKAGES_PATH=/usr/local/lib/python3.6/dist-packages \
     -D PYTHON_NUMPY_INCLUDE_DIRS=/usr/local/lib/python3.6/dist-packages/numpy/core/include \
     # -D PYTHON3_EXECUTABLE=/virtualenv/env3/bin/python \
     # -D PYTHON3_INCLUDE_DIR=/virtualenv/env3/include/python3.6m \
     # -D PYTHON3_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython3.6m.so \
     # -D PYTHON3_PACKAGES_PATH=/virtualenv/env3/lib/python3.6/site-packages \
     # -D PYTHON3_NUMPY_INCLUDE_DIRS=/virtualenv/env3/lib/python3.6/site-packages/numpy/core/include \
     -D ENABLE_FAST_MATH=1 \
     -D CUDA_FAST_MATH=1 \
     -D OPENCV_ENABLE_NONFREE=ON \
     -D OPENCV_EXTRA_MODULES_PATH=/tmp/opencv_contrib/modules \
     .. \
 && make -j8 \
 && make install \
 && ldconfig \
 && cd .. \
 && rm -rf /tmp/*


# Set CUDA-specific environment paths
ENV PATH "/usr/local/cuda/bin:${PATH}"
ENV LD_LIBRARY_PATH "/usr/local/cuda/lib64:${LD_LIBRARY_PATH}"
ENV CUDA_HOME "/usr/local/cuda"

# Because some of our scripts require `python` rather than `python3` as the executable name.
RUN ln -s /usr/bin/python3 /usr/bin/python

# Visual install verification of the OpenCV2 Python buildings
RUN python -c "import cv2; print(cv2.getBuildInformation())"
