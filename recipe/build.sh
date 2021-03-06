#!/bin/sh
set -euo pipefail

# if [[ `uname` == Darwin ]]; then
#   export LDFLAGS="-Wl,-rpath,$PREFIX/lib $LDFLAGS"
# fi

# Copy zmq library without version if not already existing

if [[ `uname` == Darwin ]]; then
    export LDFLAGS="-Wl,-rpath,$PREFIX/lib $LDFLAGS"
    # Using autoconf
    ./autogen.sh
    ./configure --prefix="$PREFIX"
    make all VERBOSE=1
    make check-verbose
else
    # Using cmake
    mkdir build
    cd build
    cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=$PREFIX ..
    make all VERBOSE=1
    ctest -V
fi

# Make all, run tests, then install
make install
