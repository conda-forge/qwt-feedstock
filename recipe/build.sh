#!/bin/bash

[[ -d build ]] || mkdir build
cd build

# Missing g++ workaround.
compiler=$(which ${GXX})
ln -s ${compiler} g++ || true
chmod +x g++
export PATH=${PWD}:${PATH}

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
