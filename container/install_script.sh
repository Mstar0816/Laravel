#!/bin/bash
#echo "Don't run this on your system!" && exit 0

# install all necessary piston dependencies
echo 'source /opt/.profile' >> /opt/.bashrc
echo 'export HOME=/opt' >> /opt/.profile
echo 'export TERM=linux' >> /opt/.profile
echo 'export PATH=$PATH:/opt/.local/bin' >> /opt/.profile
export HOME=/opt
export TERM=linux
sed -i 's/\/root/\/opt/' /etc/passwd
sed -i \
    's/http:\/\/archive.ubuntu.com\/ubuntu/http:\/\/mirror.math.princeton.edu\/pub\/ubuntu/' \
    /etc/apt/sources.list
apt-get update
apt-get install -y \
    nano wget build-essential pkg-config libxml2-dev \
    libsqlite3-dev mono-complete curl cmake libpython2.7-dev \
    ruby libtinfo-dev unzip git openssl libssl-dev sbcl libevent-dev \
    ninja-build maven

# install python2
# final binary: /opt/python2/Python-2.7.17/python
# get version: /opt/python2/Python-2.7.17/python -V
cd /opt && mkdir python2 && cd python2
wget https://www.python.org/ftp/python/2.7.17/Python-2.7.17.tar.xz
unxz Python-2.7.17.tar.xz
tar -xf Python-2.7.17.tar
cd Python-2.7.17
./configure
# open Modules/Setup and uncomment zlib line
make
echo 'export PATH=$PATH:/opt/python2/Python-2.7.17' >> /opt/.profile
source /opt/.profile

# install python3
# final binary: /opt/python3/Python-3.9.1/python
# get version: /opt/python3/Python-3.9.1/python -V
cd /opt && mkdir python3 && cd python3
wget https://www.python.org/ftp/python/3.9.1/Python-3.9.1.tar.xz
unxz Python-3.9.1.tar.xz
tar -xf Python-3.9.1.tar
cd Python-3.9.1
./configure
make
ln -s python python3.9
echo 'export PATH=$PATH:/opt/python3/Python-3.9.1' >> /opt/.profile
source /opt/.profile

# install paradoc
# this is not a binary, it is a python module
# therefore it cannot be run directly as it requires python3 to be installed
cd /opt && mkdir paradoc && cd paradoc
git clone https://github.com/betaveros/paradoc.git

# install node.js
# final binary: /opt/nodejs/node-v12.16.1-linux-x64/bin/node
# get version: /opt/nodejs/node-v12.16.1-linux-x64/bin/node -v
cd /opt && mkdir nodejs && cd nodejs
wget https://nodejs.org/dist/v12.16.1/node-v12.16.1-linux-x64.tar.xz
unxz node-v12.16.1-linux-x64.tar.xz
tar -xf node-v12.16.1-linux-x64.tar
echo 'export PATH=$PATH:/opt/nodejs/node-v12.16.1-linux-x64/bin' >> /opt/.profile
source /opt/.profile

# install typescript
# final binary: /opt/nodejs/node-v12.16.1-linux-x64/bin/tsc
# get version: /opt/nodejs/node-v12.16.1-linux-x64/bin/tsc -v
/opt/nodejs/node-v12.16.1-linux-x64/bin/npm i -g typescript

# install golang
# final binary: /opt/go/go/bin/go
# get version: /opt/go/go/bin/go version
cd /opt && mkdir go && cd go
wget https://dl.google.com/go/go1.14.1.linux-amd64.tar.gz
tar -xzf go1.14.1.linux-amd64.tar.gz
echo 'export PATH=$PATH:/opt/go/go/bin' >> /opt/.profile
echo 'export GOROOT=/opt/go/go' >> /opt/.profile
echo 'export GOCACHE=/tmp' >> /opt/.profile
source /opt/.profile

# install php
# final binary: /usr/local/bin/php
# get version: /usr/local/bin/php -v
cd /opt && mkdir php && cd php
wget https://www.php.net/distributions/php-8.0.0.tar.gz
tar -xzf php-8.0.0.tar.gz
cd php-8.0.0
./configure
make
make install

# install rust
# final binary: /usr/local/bin/rustc
# get version: /usr/local/bin/rustc --version
cd /opt && mkdir rust && cd rust
wget https://static.rust-lang.org/dist/rust-1.49.0-x86_64-unknown-linux-gnu.tar.gz
tar -xzf rust-1.49.0-x86_64-unknown-linux-gnu.tar.gz
cd rust-1.49.0-x86_64-unknown-linux-gnu
./install.sh

# install scala
# final binary: /opt/scala/scala3-3.0.0-M3/bin/scala
# get version: /opt/scala/scala3-3.0.0-M3/bin/scalac -version
cd /opt && mkdir scala && cd scala
wget https://github.com/lampepfl/dotty/releases/download/3.0.0-M3/scala3-3.0.0-M3.tar.gz
tar -xzf scala3-3.0.0-M3.tar.gz
echo 'export PATH=$PATH:/opt/scala/scala3-3.0.0-M3/bin' >> /opt/.profile
source /opt/.profile

# install swift
# final binary: /opt/swift/swift-5.1.5-RELEASE-ubuntu18.04/usr/bin/swift
# get version: /opt/swift/swift-5.1.5-RELEASE-ubuntu18.04/usr/bin/swift --version
cd /opt && mkdir swift && cd swift
wget https://swift.org/builds/swift-5.1.5-release/ubuntu1804/swift-5.1.5-RELEASE/swift-5.1.5-RELEASE-ubuntu18.04.tar.gz
tar -xzf swift-5.1.5-RELEASE-ubuntu18.04.tar.gz
echo 'export PATH=$PATH:/opt/swift/swift-5.1.5-RELEASE-ubuntu18.04/usr/bin' >> /opt/.profile
source /opt/.profile

# install nasm
# final binary: /opt/nasm/nasm-2.14.02/nasm
# get version: /opt/nasm/nasm-2.14.02/nasm -v
cd /opt && mkdir nasm && cd nasm
wget https://www.nasm.us/pub/nasm/releasebuilds/2.14.02/nasm-2.14.02.tar.gz
tar -xzf nasm-2.14.02.tar.gz
cd nasm-2.14.02
./configure
make
echo 'export PATH=$PATH:/opt/nasm/nasm-2.14.02' >> /opt/.profile
source /opt/.profile

# install java
# final binary: /opt/java/jdk-14/bin/java
# get version: /opt/java/jdk-14/bin/java -version
cd /opt && mkdir java && cd java
wget https://download.java.net/java/GA/jdk14/076bab302c7b4508975440c56f6cc26a/36/GPL/openjdk-14_linux-x64_bin.tar.gz
tar -xzf openjdk-14_linux-x64_bin.tar.gz
echo 'export PATH=$PATH:/opt/java/jdk-14/bin' >> /opt/.profile
# Scala will complain if JAVA_HOME isn't set
echo 'export JAVA_HOME=/opt/java/jdk-14' >> /opt/.profile
source /opt/.profile

# install jelly
cd /opt && mkdir jelly && cd jelly
wget https://github.com/DennisMitchell/jellylanguage/archive/master.zip
unzip master.zip
cd jellylanguage-master
python3.8 -m pip install .
sed -i 's/\/usr\/local\/bin\/python3.8/\/opt\/python3\/Python-3.8.2\/python3.8/' /usr/local/bin/jelly

# install julia
# final binary: /opt/julia/julia-1.5.0/bin/julia
# get version: /opt/julia/julia-1.5.0/bin/julia --version
cd /opt && mkdir julia && cd julia
wget https://julialang-s3.julialang.org/bin/linux/x64/1.5/julia-1.5.0-linux-x86_64.tar.gz
tar -xzf julia-1.5.0-linux-x86_64.tar.gz
echo 'export PATH=$PATH:/opt/julia/julia-1.5.0/bin' >> /opt/.profile
source /opt/.profile

# install kotlin
# final binary: /opt/kotlinc/bin/kotlinc
# get version: /opt/kotlinc/bin/kotlinc -version
cd /opt
wget https://github.com/JetBrains/kotlin/releases/download/v1.4.10/kotlin-compiler-1.4.10.zip
unzip kotlin-compiler-1.4.10.zip
rm kotlin-compiler-1.4.10.zip
echo 'export PATH=$PATH:/opt/kotlinc/bin' >> /opt/.profile
source /opt/.profile

# install elixir and erlang
# final binary: /opt/elixir/bin/elixir
# get version: /opt/elixir/bin/elixir --version
# erlang
cd /opt && mkdir erlang && cd erlang
wget http://erlang.org/download/otp_src_23.0.tar.gz
gunzip -c otp_src_23.0.tar.gz | tar xf -
cd otp_src_23.0 && ./configure
make
echo 'export PATH=$PATH:/opt/erlang/otp_src_23.0/bin' >> /opt/.profile
source /opt/.profile
# elixir
cd /opt && mkdir elixir && cd elixir
wget https://github.com/elixir-lang/elixir/releases/download/v1.10.3/Precompiled.zip
mkdir elixir-1.10.3 && unzip Precompiled.zip -d elixir-1.10.3/
echo 'export PATH=$PATH:/opt/elixir/elixir-1.10.3/bin' >> /opt/.profile
source /opt/.profile

# install emacs
# final binary: /opt/emacs/emacs-26.3/src/emacs
# get version: /opt/emacs/emacs-26.3/src/emacs --version
cd /opt && mkdir emacs && cd emacs
wget https://mirrors.ocf.berkeley.edu/gnu/emacs/emacs-26.3.tar.xz
tar -xf emacs-26.3.tar.xz
rm emacs-26.3.tar.xz
cd emacs-26.3
./configure --with-gnutls=no
make
echo 'export PATH=$PATH:/opt/emacs/emacs-26.3/src' >> /opt/.profile
source /opt/.profile

# install lua
# final binary: /opt/lua/lua54/src/lua
# get version: /opt/lua/lua54/src/lua -v
cd /opt && mkdir lua && cd lua
wget https://sourceforge.net/projects/luabinaries/files/5.4.0/Docs%20and%20Sources/lua-5.4.0_Sources.tar.gz/download
tar -xzf download
cd lua54
make
echo 'export PATH=$PATH:/opt/lua/lua54/src' >> /opt/.profile
source /opt/.profile

# install haskell
# final binary: /usr/bin/ghc
# get version: /usr/bin/ghc --version
apt install -y ghc

# install deno
# final binary: /opt/.deno/bin/deno
# get version: /opt/.deno/bin/deno --version
cd /opt && mkdir deno && cd deno
curl -fsSL https://deno.land/x/install/install.sh | sh
echo 'export DENO_INSTALL="/opt/.deno"' >> /opt/.profile
echo 'export PATH="$DENO_INSTALL/bin:$PATH"' >> /opt/.profile
source /opt/.profile

# install brainfuck
cd /opt && mkdir bf && cd bf
git clone https://github.com/texus/Brainfuck-interpreter
cd Brainfuck-interpreter
echo 'export PATH=$PATH:/opt/bf/Brainfuck-interpreter' >> /opt/.profile
source /opt/.profile

# install crystal
# final binary: /opt/crystal/crystal-0.35.1-1/bin/crystal
# get version: /opt/crystal/crystal-0.35.1-1/bin/crystal -v
cd /opt && mkdir crystal && cd crystal
wget https://github.com/crystal-lang/crystal/releases/download/0.35.1/crystal-0.35.1-1-linux-x86_64.tar.gz
tar -xzf crystal-0.35.1-1-linux-x86_64.tar.gz
echo 'export PATH="$PATH:/opt/crystal/crystal-0.35.1-1/bin:$PATH"' >> /opt/.profile
source /opt/.profile

# install d
# final binary: /opt/d/dmd2/linux/bin64/dmd
# get version: /opt/d/dmd2/linux/bin64/dmd --version
cd /opt && mkdir d && cd d
wget http://downloads.dlang.org/releases/2.x/2.095.0/dmd.2.095.0.linux.tar.xz
unxz dmd.2.095.0.linux.tar.xz
tar -xf dmd.2.095.0.linux.tar
echo 'export PATH=$PATH:/opt/d/dmd2/linux/bin64' >> /opt/.profile
source /opt/.profile

# install zig
# final binary: /opt/zig/zig
# get version: /opt/zig/zig version
cd /opt && mkdir zig && cd zig
wget https://ziglang.org/download/0.7.1/zig-linux-x86_64-0.7.1.tar.xz
tar -xf zig-linux-x86_64-0.7.1.tar.xz
mv zig-linux-x86_64-0.7.1 zig
rm zig-linux-x86_64-0.7.1.tar.xz
echo 'export PATH=$PATH:/opt/zig/zig' >> /opt/.profile
source /opt/.profile

# install nim
# final binary: /opt/nim/bin/nim
# get version: /opt/nim/bin/nim -v
cd /opt && mkdir nim && cd nim
wget https://nim-lang.org/download/nim-1.4.0-linux_x64.tar.xz
unxz nim-1.4.0-linux_x64.tar.xz
tar -xf nim-1.4.0-linux_x64.tar
cd nim-1.4.0
./install.sh /opt
echo 'export PATH=$PATH:/opt/nim/bin' >> /opt/.profile
source /opt/.profile

# install 05AB1E
# final binary: /opt/05AB1E/05AB1E/osabie
# requires Elixir to install
cd /opt && mkdir 05AB1E && cd 05AB1E
git clone https://github.com/Adriandmen/05AB1E.git
cd 05AB1E
mix local.hex --force
mix deps.get --force
MIX_ENV=prod mix escript.build --force
echo 'export PATH=$PATH:/opt/05AB1E/05AB1E' >> /opt/.profile
source /opt/.profile

# install prolog
# final binary: /opt/swipl/swipl-<version>/build/src/swipl
cd /opt && mkdir swipl && cd swipl
SUB_DIR=swipl-8.2.4
wget https://www.swi-prolog.org/download/stable/src/$SUB_DIR.tar.gz
tar -xf $SUB_DIR.tar.gz
rm $SUB_DIR.tar.gz
cd $SUB_DIR
mkdir build
cd build
cmake -DSWIPL_PACKAGES_JAVA=OFF -DSWIPL_PACKAGES_X=OFF -DMULTI_THREADED=OFF -DINSTALL_DOCUMENTATION=OFF -G Ninja ..
ninja
echo "export PATH=\$PATH:/opt/swipl/$SUB_DIR/build/src" >> /opt/.profile
source /opt/.profile

# install lolcode
# final binary: /opt/lolcode/bin/lci
cd /opt
git clone https://github.com/justinmeza/lci.git lolcode
cd lolcode
mkdir bin
cd bin
cmake ..
make
echo 'export PATH=$PATH:/opt/lolcode/bin' >> /opt/.profile
source /opt/.profile

# install clojure
# final binary: /opt/clojure/bin/clojure
# get version: /opt/clojure/bin/clojure -version
cd /opt && mkdir clojure && cd clojure
git clone https://github.com/clojure/clojure.git
cd clojure
mvn -Plocal -Dmaven.test.skip=true package

# create runnable users and apply limits
for i in {1..150}; do
    useradd -M runner$i
    usermod -d /tmp runner$i
    echo "runner$i soft nproc 64" >> /etc/security/limits.conf
    echo "runner$i hard nproc 64" >> /etc/security/limits.conf
    echo "runner$i soft nofile 2048" >> /etc/security/limits.conf
    echo "runner$i hard nofile 2048" >> /etc/security/limits.conf
done

# remove any lingering write access to others
cd /opt
chown -R root: *
chmod -R o-w *

# cleanup
rm -rf /home/ubuntu
chmod 777 /tmp

# disable cron
systemctl stop cron
systemctl disable cron
