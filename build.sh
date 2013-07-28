#!/bin/bash

DATE="$(date +%Y%m%d)"
P=`pwd`
# target is php version 5.3, change zend api version for others, must be built on ubu lucid
ZEND_VERSION="20090626"

check() {
  apt-get install php5-dev python-software-properties re2c -y
  yes | add-apt-repository ppa:svn/ppa
  apt-get update
  apt-get install subversion libsvn-dev -y
}

build_phpsvn() {
  cd $P
  phpize
  ./configure
  make
}

pack_phpsvn() {
  cd $P
  
  if [[ ! -d build/phpsvn ]] ; then
    mkdir -p build/phpsvn
  fi
  
  rm build/phpsvn/* -rf  
  mkdir -p $P/build/phpsvn/usr/lib/php5/$ZEND_VERSION
  
  cp $P/modules/svn.so $P/build/phpsvn/usr/lib/php5/$ZEND_VERSION/
  
  cd $P/build/phpsvn
  
  fpm -f -s dir -t deb -n php-svn -v $DATE usr
}

set -x
set -e

check
build_phpsvn
pack_phpsvn
