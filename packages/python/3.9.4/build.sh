#!/bin/bash

PREFIX=$(realpath $(dirname $0))

mkdir -p build

cd build

curl "https://www.python.org/ftp/python/3.9.4/Python-3.9.4.tgz" -o python.tar.gz
tar xzf python.tar.gz --strip-components=1
rm python.tar.gz

./configure --prefix "$PREFIX" --with-ensurepip=install
make -j$(nproc)
make install -j$(nproc)

cd ..

rm -rf build 

bin/pip3 install numpy scipy pandas pycrypto whoosh bcrypt passlib sympy
