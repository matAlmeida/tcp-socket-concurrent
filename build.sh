#!/bin/bash

echo "Starting Build..."

#Polyfill for MacOsX
realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

GOARCH=`uname -m`
case "$GOARCH" in
  i?86) GOARCH="386" ;;
  x86_64) GOARCH="amd64" ;;
  arm*) GOARCH="arm" ;;
esac

GOOS="$OSTYPE"
case "$OSTYPE" in
  darwin*)  GOOS="darwin" ;;
  linux*)   GOOS="linux" ;;
  bsd*)     GOOS="freebsd" ;;
  msys*)    GOOS="windows" ;;
  *)        GOOS="unknown: $OSTYPE" ;;
esac

build_directory="dist/"
directory=$(temp=$( realpath "$build_directory"  ) && dirname "$temp")
GOBIN=$directory/$build_directory
if [ -d $GOBIN ]; then
  rm -rf $GOBIN
fi
mkdir $GOBIN
env GOOS=$GOOS GOARCH=$GOARCH go build -v server.go
env GOOS=$GOOS GOARCH=$GOARCH go build -v client.go
mv client $GOBIN
mv server $GOBIN

echo "Build Finished."
