#!/bin/bash

if [[ $target_platform == linux* ]]; then
  ln -s -t "${BUILD_PREFIX}/${HOST}/sysroot/usr/lib64/" $PREFIX/lib/libexpat*
fi

[[ -d build ]] || mkdir build
cd build

# Missing g++ workaround.
ln -s ${GXX} g++ || true
chmod +x g++
export PATH=${PWD}:${PATH}

qmake ../qwt.pro

make -j${CPU_COUNT}
make check
make install

# No test suite, but we can build examples in "examples/" as a check.
echo "Building examples to test library install"
mkdir -p examples
cd examples/

qmake ../../examples/examples.pro
make -j${CPU_COUNT}
