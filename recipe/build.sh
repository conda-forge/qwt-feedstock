#!/bin/bash

sed -i.bak "/silent/d" qwtbuild.pri

[[ -d build ]] || mkdir build
cd build

# Missing g++ workaround.
ln -sv ${CXX} ${BUILD_PREFIX}/bin/g++
which g++

qmake6 -query
qmake6 ../qwt.pro

make -j${CPU_COUNT}
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
make check
fi
make install

# No test suite, but we can build examples in "examples/" as a check.
echo "Building examples to test library install"
mkdir -p examples
cd examples/

qmake6 ../../examples/examples.pro
make -j${CPU_COUNT}
