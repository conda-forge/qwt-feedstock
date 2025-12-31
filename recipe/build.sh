#!/bin/bash

set -ex

sed -i.bak "/silent/d" qwtbuild.pri

if test "${CONDA_BUILD_CROSS_COMPILATION}" == "1"; then
  CMAKE_ARGS="${CMAKE_ARGS} -DQT_HOST_PATH=${BUILD_PREFIX}"
  if test `uname` = "Darwin"; then
    cmake -LAH ${CMAKE_ARGS} -B build .
    cmake --build build --target install --parallel ${CPU_COUNT}
    exit 0
  fi
fi

mkdir build && cd build

qmake6 -early \
    PREFIX=$PREFIX \
    LIB_DIR=$PREFIX/lib \
    INCLUDE_DIR=$PREFIX/include \
    QMAKE_CC=${CC} \
    QMAKE_CXX=${CXX} \
    QMAKE_LINK=${CXX} \
    QMAKE_RANLIB=${RANLIB} \
    QMAKE_OBJDUMP=${OBJDUMP} \
    QMAKE_STRIP=${STRIP} \
    QMAKE_AR="${AR} cqs" \
    ../qwt.pro

make -j${CPU_COUNT}
make install

# No test suite, but we can build examples in "examples/" as a check.
echo "Building examples to test library install"
mkdir -p examples
cd examples/

qmake6 ../../examples/examples.pro
make -j${CPU_COUNT}
