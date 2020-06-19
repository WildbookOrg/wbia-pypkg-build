FROM quay.io/pypa/manylinux2010_x86_64

ENV PYTHON=/opt/python/cp36-cp36m/bin/python

# ######################################
# Install OpenCV

# Based on installation instructions from:
# https://linuxize.com/post/how-to-install-opencv-on-centos-7/
# &&
# https://docs.opencv.org/3.4/dd/dd5/tutorial_py_setup_in_fedora.html

RUN set -ex \
    && yum install -y \
       epel-release \
       git \
       gcc \
       gcc-c++ \
       cmake3 \
       qt5-qtbase-devel \
       python \
       python-devel \
       python-pip \
       cmake \
       python-devel \
       python34-numpy \
       gtk2-devel \
       libpng-devel \
       jasper-devel \
       openexr-devel \
       libwebp-devel \
       libjpeg-turbo-devel \
       libtiff-devel \
       libdc1394-devel \
       tbb-devel \
       numpy \
       eigen3-devel \
       gstreamer-plugins-base-devel \
       freeglut-devel \
       mesa-libGL \
       mesa-libGL-devel \
       boost \
       boost-thread \
       boost-devel \
       libv4l-devel

# ??? Installing newer versions of gstreamer?
# This line was stollen from https://quay.io/repository/erotemic/manylinux-opencv/manifest/sha256:1d81c95ce784779f0281321b5f1ef71f86f28c6f107936b492d4677dbb716d18
# This resolves a compilation error in opencv.
RUN curl -O https://raw.githubusercontent.com/torvalds/linux/v4.14/include/uapi/linux/videodev2.h && curl -O https://raw.githubusercontent.com/torvalds/linux/v4.14/include/uapi/linux/v4l2-common.h && curl -O https://raw.githubusercontent.com/torvalds/linux/v4.14/include/uapi/linux/v4l2-controls.h && curl -O https://raw.githubusercontent.com/torvalds/linux/v4.14/include/linux/compiler.h && mv videodev2.h v4l2-common.h v4l2-controls.h compiler.h /usr/include/linux

ARG OPENCV_VERSION=4.2.0

RUN set -ex \
    && cd /tmp \
    && git clone https://github.com/opencv/opencv.git \
    && git clone https://github.com/opencv/opencv_contrib.git \
    && cd /tmp/opencv \
    && git checkout $OPENCV_VERSION \
    && cd /tmp/opencv_contrib \
    && git checkout $OPENCV_VERSION \
    && rm -rf /tmp/opencv/build \
    && mkdir -p /tmp/opencv/build \
    && cd /tmp/opencv/build \
    && cmake3 -G "Unix Makefiles" \
     -D CMAKE_C_COMPILER=gcc \
     -D CMAKE_CXX_COMPILER=g++ \
     -D CMAKE_BUILD_TYPE=RELEASE \
     -D CMAKE_INSTALL_PREFIX=/usr/local \
     ############################################################
     -D OPENCV_GENERATE_PKGCONFIG=ON \
     -D ENABLE_PRECOMPILED_HEADERS=OFF \
     -D BUILD_opencv_apps=OFF \
     -D BUILD_SHARED_LIBS=OFF \
     -D BUILD_TESTS=OFF \
     -D BUILD_PERF_TESTS=OFF \
     -D BUILD_DOCS=OFF \
     -D BUILD_EXAMPLES=OFF \
     -D BUILD_opencv_java=OFF \
     -D BUILD_opencv_python3=ON \
     -D BUILD_NEW_PYTHON_SUPPORT=ON \
     -D INSTALL_C_EXAMPLES=OFF \
     -D INSTALL_PYTHON_EXAMPLES=OFF \
     -D INSTALL_CREATE_DISTRIB=ON \
     -D BUILD_JPEG=ON \
     -D BUILD_HDR=ON \
     -D WITH_MATLAB=OFF \
     -D WITH_TBB=ON \
     -D WITH_CUDA=OFF \
     -D WITH_CUBLAS=0 \
     -D WITH_EIGEN=ON \
     -D WITH_AVFOUNDATION=ON \
     -D WITH_JPEG=ON \
     -D BUILD_TIFF=ON \
     -D WITH_HDR=ON \
     -D WITH_V4L=ON \
     -D WITH_GDAL=ON \
     -D WITH_WIN32UI=OFF \
     -D WITH_QT=OFF \
     -D PYTHON_EXECUTABLE=/opt/python/cp36-cp36m/bin/python \
     -D PYTHON_INCLUDE_DIR=/opt/python/cp36-cp36m/include/python3.6m \
     # -D PYTHON_LIBRARY=???/libpython3.6m.so \
     -D PYTHON_PACKAGES_PATH=/opt/python/cp36-cp36m/lib/python3.6/site-packages/ \
     # -D PYTHON_NUMPY_INCLUDE_DIRS=???/-packages/numpy/core/include \
     -D ENABLE_FAST_MATH=1 \
     -D CUDA_FAST_MATH=1 \
     -D OPENCV_ENABLE_NONFREE=ON \
     -D OPENCV_EXTRA_MODULES_PATH=/tmp/opencv_contrib/modules \
     .. \
    && make -j9 \
    && make install \
    && ldconfig \
    && cd .. \
    && rm -rf /tmp/*

# ######################################
# Install common tools

RUN $PYTHON -m pip install -q --no-cache-dir --upgrade pip && $PYTHON -m pip install -q --no-cache-dir cmake ninja scikit-build wheel numpy
