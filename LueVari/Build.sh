#!/bin/bash
# Fetch software and setup directories
git clone https://github.com/cosmo-team/cosmo/
cd cosmo/
git checkout VARI
mkdir 3rd_party_src
mkdir -p 3rd_party_inst/boost
cd 3rd_party_src

#Clone all the tools
git clone https://github.com/refresh-bio/KMC  #KMC
cd KMC
git checkout f090276855a3f7c0b14e9f3abc8c99d3213247b3
cd ..
git clone https://github.com/cosmo-team/sdsl-lite.git  #sdsl-lite
cd sdsl-lite
git checkout 9fa981958a9d2ddade12d083548f2b09939514fb
cd ..
git clone https://github.com/stxxl/stxxl  #stxxl
cd stxxl
git checkout 5b9663e6b769748f3b3d3a9a779b4b89e24d7a27
cd ..
git clone https://github.com/cosmo-team/tclap  #tclap
cd tclap
git checkout f41dcb5ce3d063c9fe95623193bba693338f3edb
cd ..
wget http://sourceforge.net/projects/boost/files/boost/1.54.0/boost_1_54_0.tar.bz2  #boost
tar -xjf boost_1_54_0.tar.bz2

# Build the five dependencies
cd boost_1_54_0
./bootstrap.sh --prefix=../../3rd_party_inst/boost
./b2 install
cd ..

cd sdsl-lite/
/usr/bin/time sh install.sh /home/noyes046/elder099/LueVari/cosmo/3rd_party_inst
cd ..

cd stxxl
mkdir build
cd build
CC=gcc CXX=g++ cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/home/noyes046/elder099/LueVari/cosmo/3rd_party_inst -DBUILD_STATIC_LIBS=ON
make
make install
cd ../..

cd KMC
make
cd ..

cd tclap/
autoreconf -fvi
./configure --prefix=/home/noyes046/elder099/LueVari/cosmo/3rd_party_inst
make
make install
cd ../..

# Build VARI
make
