#!/bin/bash

mkdir build && cd build

qmake -early QWT_INSTALL_PREFIX=$PREFIX QMAKE_CXXFLAGS="${CXXFLAGS}" QMAKE_CXX=${CXX} QMAKE_LFLAGS="${LDFLAGS}" QMAKE_LINK=${CXX} ../qwt.pro


make
make check
make install

# No test suite, but we can build examples in "examples/" as a check
echo "Building examples to test library install"
mkdir -p examples
cd examples/

qmake -early QMAKE_CXXFLAGS="${CXXFLAGS}" QMAKE_CXX=${CXX} QMAKE_LFLAGS="${LDFLAGS}" QMAKE_LINK=${CXX} ../../examples/examples.pro
make

