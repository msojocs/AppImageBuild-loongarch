#! /bin/bash

set -xe

git clone https://github.com/rhash/RHash.git -b v"$RHASH_VERSION" rhash-"$RHASH_VERSION"

cd rhash-"$RHASH_VERSION"

# needed for automake
export PATH=/deps/bin:"$PATH"

EXTRA_CONFIGURE_FLAGS=
if [ "$ARCH" == "i386" ]; then
    EXTRA_CONFIGURE_FLAGS=" --build=i686-linux-gnu --host=i686-linux-gnu --target=i686-linux-gnu"
elif [ "$ARCH" == "armhf" ] || [ "$ARCH" == "aarch64" ]; then
    EXTRA_CONFIGURE_FLAGS=" --host=$DEBARCH --target=$DEBARCH"
fi

[ -f autogen.sh ] && ./autogen.sh

./configure --prefix=/deps $EXTRA_CONFIGURE_FLAGS

set +x
echo "+ make -j$(nproc)" 1>&2

if [ -z $VERBOSE ]; then
    make -j$(nproc) 2>&1 | while read line; do
        echo -n .
    done
    echo
else
    make -j$(nproc)
fi
set -x

make install

cd ../../
rm -rf rhash-"$RHASH_VERSION"/
