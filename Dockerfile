FROM quay.io/pypa/manylinux2010_x86_64

MAINTAINER Wild Me <dev@wildme.org>

ARG OPENCV_VERSION=3.4.11

ENV WORKSPACE=/tmp

ENV VIRTUAL_ENV=/usr/local

ENV PATH="${PATH}:/opt/python/cp36-cp36m/bin"

RUN set -ex \
 && yum install -y \
        epel-release \
        cmake3 \
        git \
        gflags-devel \
        eigen3-devel \
        gtk2-devel \
 && yum clean all \
 && rm -rf /var/cache/yum

RUN ln -s /opt/python/cp36-cp36m/bin/python /usr/bin/python3

RUN set -ex \
 && python3 -m pip install -q --no-cache-dir --upgrade pip \
 && python3 -m pip install -q --no-cache-dir --upgrade setuptools wheel \
 && python3 -m pip install -q --no-cache-dir --upgrade ninja scikit-build numpy

RUN set -ex \
 && echo "Using OPENCV_VERSION = ${OPENCV_VERSION}" \
 && echo "Using WORKSPACE      = ${WORKSPACE}" \
 && echo "Using VIRTUAL_ENV    = ${VIRTUAL_ENV}" \
 && echo "Using python3        = $(which python3)"

# Install OpenCV
RUN set -ex \
 && git clone https://github.com/opencv/opencv.git ${WORKSPACE}/opencv \
 && git clone https://github.com/opencv/opencv_contrib.git ${WORKSPACE}/opencv_contrib \
 && cd ${WORKSPACE}/opencv \
 && git checkout ${OPENCV_VERSION} \
 && cd ${WORKSPACE}/opencv_contrib \
 && git checkout ${OPENCV_VERSION} \
 && rm -rf ${WORKSPACE}/opencv/build \
 && mkdir -p ${WORKSPACE}/opencv/build \
 && cd ${WORKSPACE}/opencv/build \
 && cmake3 \
        -D CMAKE_C_COMPILER=gcc \
        -D CMAKE_CXX_COMPILER=g++ \
        -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=${VIRTUAL_ENV} \
        -D OPENCV_GENERATE_PKGCONFIG=ON \
        -D ENABLE_PRECOMPILED_HEADERS=OFF \
        -D BUILD_SHARED_LIBS=OFF \
        -D BUILD_TESTS=OFF \
        -D BUILD_PERF_TESTS=OFF \
        -D BUILD_DOCS=OFF \
        -D BUILD_EXAMPLES=OFF \
        -D BUILD_opencv_apps=OFF \
        -D BUILD_opencv_freetype=OFF \
        -D BUILD_opencv_hdf=OFF \
        -D BUILD_opencv_java=OFF \
        -D BUILD_opencv_python2=OFF \
        -D BUILD_opencv_python3=ON \
        -D BUILD_NEW_PYTHON_SUPPORT=ON \
        -D INSTALL_C_EXAMPLES=OFF \
        -D INSTALL_PYTHON_EXAMPLES=OFF \
        -D INSTALL_CREATE_DISTRIB=ON \
        -D BUILD_ZLIB=ON \
        -D BUILD_JPEG=ON \
        -D BUILD_WEBP=ON \
        -D BUILD_PNG=ON \
        -D BUILD_TIFF=ON \
        -D BUILD_JASPER=ON \
        -D BUILD_OPENEXR=ON \
        -D WITH_MATLAB=OFF \
        -D WITH_TBB=OFF \
        -D WITH_CUDA=OFF \
        -D WITH_CUBLAS=0 \
        -D WITH_EIGEN=ON \
        -D WITH_1394=OFF \
        -D WITH_FFMPEG=OFF \
        -D WITH_GSTREAMER=OFF \
        -D WITH_V4L=OFF \
        -D WITH_AVFOUNDATION=OFF \
        -D WITH_TESSERACT=OFF \
        -D WITH_HDR=ON \
        -D WITH_GDAL=OFF \
        -D WITH_WIN32UI=OFF \
        -D WITH_QT=OFF \
        -D PYTHON3_EXECUTABLE=$(which python3) \
        -D PYTHON3_INCLUDE_DIR=$(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
        -D PYTHON3_INCLUDE_DIR2=$(python3 -c "from os.path import dirname; from distutils.sysconfig import get_config_h_filename; print(dirname(get_config_h_filename()))") \
        -D PYTHON3_LIBRARY=$(python3 -c "from distutils.sysconfig import get_config_var;from os.path import dirname,join ; print(join(dirname(get_config_var('LIBPC')),get_config_var('LDLIBRARY')))") \
        -D PYTHON3_NUMPY_INCLUDE_DIRS=$(python3 -c "import numpy; print(numpy.get_include())") \
        -D PYTHON3_PACKAGES_PATH=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
        -D ENABLE_FAST_MATH=1 \
        -D CUDA_FAST_MATH=1 \
        -D OPENCV_ENABLE_NONFREE=ON \
        -D OPENCV_EXTRA_MODULES_PATH=${WORKSPACE}/opencv_contrib/modules \
        .. \
 && make -j9 \
 && make install \
 && ldconfig \
 && rm -rf ${WORKSPACE}/opencv \
 && rm -rf ${WORKSPACE}/opencv_contrib
