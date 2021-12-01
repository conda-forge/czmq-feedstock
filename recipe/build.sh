#!/bin/sh
set -euo pipefail

# if [[ `uname` == Darwin ]]; then
#   export LDFLAGS="-Wl,-rpath,$PREFIX/lib $LDFLAGS"
# fi

# Copy zmq library without version if not already existing

if [[ `uname` == Darwin ]]; then
    # Get an updated config.sub and config.guess
    cp $BUILD_PREFIX/share/gnuconfig/config.* .

    export LDFLAGS="-Wl,-rpath,$PREFIX/lib $LDFLAGS"
    # Using autoconf
    ./autogen.sh
    ./configure --prefix="$PREFIX"
    make all VERBOSE=1

    if [[ "$CONDA_BUILD_CROSS_COMPILATION" != "1" ]]; then
	make check-verbose
    fi
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
