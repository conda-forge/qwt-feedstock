#!/bin/bash

sed -i.bak "/silent/d" qwtbuild.pri

mkdir build && cd build

qmake6 -early \
    QMAKE_CC=${CC} \
    QMAKE_CXX=${CXX} \
    QMAKE_LINK=${CXX} \
    QMAKE_RANLIB=${RANLIB} \
    QMAKE_OBJDUMP=${OBJDUMP} \
    QMAKE_STRIP=${STRIP} \
    QMAKE_AR="${AR} cqs" \
    ../qwt.pro

if test `uname` = "Darwin"
then
    if test "$CONDA_BUILD_CROSS_COMPILATION" = "1"
    then
        echo "grep..."
        which grep
        echo "lib..."
        grep -nr OpenGLWidgets . || echo "nope"
        echo "arch..."
        grep -nr "arch x86_64" . || echo "nope"
        echo "include..."
        grep -nr "include/qt6/QtPrintSupport" .  || echo "nope"
    fi
fi
cat Makefile
cat src/Makefile

make -j${CPU_COUNT}
make install

# No test suite, but we can build examples in "examples/" as a check.
echo "Building examples to test library install"
mkdir -p examples
cd examples/

qmake6 ../../examples/examples.pro
make -j${CPU_COUNT}
