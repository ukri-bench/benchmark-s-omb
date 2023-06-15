#!/bin/bash

omb_n10=$(pwd)
omb_version=osu-micro-benchmarks-7.1-1
omb_site=https://mvapich.cse.ohio-state.edu/download/mvapich

wget $omb_site/$omb_version.tar.gz
tar -xzf $omb_version.tar.gz
cd $omb_version

./configure \
  CC=cc  \
  CXX=CC \
  --prefix=$(omb_n10)/osu-micro-benchmarks-7.1-1-install
  --enable-cuda=basic \
  --with-cuda=$CUDA_HOME

make
make install
