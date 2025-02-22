#! /bin/bash

set -xe

git clone https://dev.gnupg.org/source/libgcrypt.git -b libgcrypt-"$LIBGCRYPT_VERSION" libgcrypt-"$LIBGCRYPT_VERSION"

cd libgcrypt-"$LIBGCRYPT_VERSION"

# needed for automake
export PATH=/deps/bin:"$PATH"

EXTRA_CONFIGURE_FLAGS=
if [ "$ARCH" == "i386" ]; then
    EXTRA_CONFIGURE_FLAGS=" --build=i686-linux-gnu --host=i686-linux-gnu --target=i686-linux-gnu"
elif [ "$ARCH" == "armhf" ] || [ "$ARCH" == "aarch64" ]; then
    EXTRA_CONFIGURE_FLAGS=" --host=$DEBARCH --target=$DEBARCH"
elif [ "$ARCH" == "loongarch64" ] || [ "$ARCH" == "loong64" ]; then
    EXTRA_CONFIGURE_FLAGS=" --build=loongarch64-unknown-linux-gnu --host=loongarch64-unknown-linux-gnu --target=loongarch64-unknown-linux-gnu "
fi

[ -f autogen.sh ] && ./autogen.sh

./configure --enable-maintainer-mode --prefix=/deps --disable-doc $EXTRA_CONFIGURE_FLAGS

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
rm -rf libgcrypt-"$LIBGCRYPT_VERSION"/
