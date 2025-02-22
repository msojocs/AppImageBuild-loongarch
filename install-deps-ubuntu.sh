#! /bin/bash

set -e
set -x

apt-get update

packages=(
    libfuse-dev
    desktop-file-utils
    ca-certificates
    gcc
    g++
    make
    build-essential
    git
    automake
    autoconf
    libtool
    libtool-bin
    patch
    wget
    vim-common
    desktop-file-utils
    pkg-config
    libarchive-dev
    librsvg2-dev
    librsvg2-bin
    liblzma-dev
    cmake
    libssl-dev
    zsync
    fuse
    gettext
    bison
    texinfo
    rhash
)

apt-get install -y "${packages[@]}"
