#!/bin/bash

omb_version=osu-micro-benchmarks-7.1.1
omb_site=https://mvapich.cse.ohio-state.edu/download/mvapich

wget $omb_site/$omb_version.tar.gz
tar -xzf $omb_version.tar.gz
cd $omb_version

./configure \
  CC=cc  \
  CXX=CC \
  --enable-cuda=basic \
  --with-cuda=FIXME

make
make install
