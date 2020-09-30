#!/bin/bash
PREFIX=${HOME}/.local/vim
mkdir -p $PREFIX
docker run --rm --name vim-builder \
--mount type=bind,src=${PREFIX},dst=${PREFIX} \
ubuntu:18.04 \
bash -c "
set -e
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential gettext libtinfo-dev libacl1-dev libgpm-dev git
apt-get clean
rm -rf /var/lib/apt/lists/*
git clone --depth 1 https://github.com/vim/vim
cd vim
LDFLAGS='-static' ./configure --with-features=huge --enable-fail-if-missing --prefix=$PREFIX
make
rm -rf $PREFIX/*
make install
chown -R $(id -u):$(id -g) $PREFIX
"
