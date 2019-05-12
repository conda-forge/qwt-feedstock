#!/bin/bash

if [[ $target_platform == linux* ]]; then
  export QMAKE_LFLAGS="-Wl,-rpath-link,$PREFIX/lib -Wl,-rpath-link,${BUILD_PREFIX}/${HOST}/sysroot/usr/lib64/"
fi

[[ -d build ]] || mkdir build
cd build

# Missing g++ workaround.
ln -s ${GXX} g++ || true
chmod +x g++
export PATH=${PWD}:${PATH}

export QMAKE_CXX=${GXX}
qmake ../qwt.pro

make
make check
make install

# No test suite, but we can build examples in "examples/" as a check.
echo "Building examples to test library install"
mkdir -p examples
cd examples/

qmake ../../examples/examples.pro
make
