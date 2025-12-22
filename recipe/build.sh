#!/bin/bash

sed -i.bak "/silent/d" qwtbuild.pri

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
