#!/bin/bash

[[ -d build ]] || mkdir build
cd build

# Missing g++ workaround.
ln -s ${GXX} g++ || true
chmod +x g++
export PATH=${PWD}:${PATH}

export QMAKE_CXX=${GXX}
QWT_INSTALL_PREFIX=$PREFIX qmake ../qwt.pro

make
make check
make install

# No test suite, but we can build examples in "examples/" as a check
echo "Building examples to test library install"
mkdir -p examples
cd examples/

qmake ../../examples/examples.pro
make
