#!/bin/bash
# Created by Matheus Almeida [https://github.com/matalmeida]

usage="\n$(basename "$0") [-h | --help] <GO_FILE> [TARGET_SYSTEM]
\n\n
where:\n
\t	-h, --help	show this help text\n
\t	-a, --all	will build the file for Linux, MacOS and Windows\n
inputs:\n
\t	<GO_FILE>	path to the the go file to be built"

# if [ $# -eq 0 ]; then
#   echo -e "No arguments supplied.\n\nRun $0 -h to see a helpful text"
# 	exit 1
# fi

if [ "$1" == "-h" ]; then
  echo -e $usage
  exit 0
fi

if [ "$1" == "--help" ]; then
  echo -e $usage
  exit 0
fi

BUILD_FOR_ALL="false"
if [ "$1" == "-a" ]; then
  BUILD_FOR_ALL="true"
fi

if [ "$1" == "--all" ]; then
  BUILD_FOR_ALL="true"
fi

if [ "$2" == "-a" ]; then
  BUILD_FOR_ALL="true"
fi

if [ "$2" == "--all" ]; then
  BUILD_FOR_ALL="true"
fi

#Polyfill for MacOsX
realpath() {
  [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

build_directory="dist"
directory=$(temp=$( realpath "$build_directory"  ) && dirname "$temp")
GOBIN=$directory/$build_directory

if [ "$BUILD_FOR_ALL" == "false" ]; then
  echo "Starting Build..."
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

  if [ -d $GOBIN ]; then
    rm -rf $GOBIN
  fi
  mkdir $GOBIN

  echo "Building Server..."
  env GOOS=$GOOS GOARCH=$GOARCH go build server.go
  echo "Building Client..."
  env GOOS=$GOOS GOARCH=$GOARCH go build client.go
  mkdir $GOBIN/$OSTYPE
  mv client $GOBIN/$OSTYPE
  mv server $GOBIN/$OSTYPE
  echo "Compressing Files..."
  zip -r $GOBIN/$OSTYPE.zip $GOBIN/$OSTYPE
  echo "Build Finished."
fi

if [ "$BUILD_FOR_ALL" == "true" ]; then
  if [ -d $GOBIN ]; then
    rm -rf $GOBIN
  fi
  mkdir $GOBIN

  echo "Build for Windows..."
  GOOS="windows"
  echo "\t ix86.."
  GOARCH="386"
  echo -e "\t \t Building Server..."
  env GOOS=$GOOS GOARCH=$GOARCH go build server.go
  echo -e "\t \t Building Client..."
  env GOOS=$GOOS GOARCH=$GOARCH go build client.go
  TARGET_FOLDER=$GOBIN/$GOOS/$GOARCH
  mkdir -p $TARGET_FOLDER
  mv client.exe $TARGET_FOLDER
  mv server.exe $TARGET_FOLDER
  echo "\t x86_64.."
  GOARCH="amd64"
  echo -e "\t \t Building Server..."
  env GOOS=$GOOS GOARCH=$GOARCH go build server.go
  echo -e "\t \t Building Client..."
  env GOOS=$GOOS GOARCH=$GOARCH go build client.go
  TARGET_FOLDER=$GOBIN/$GOOS/$GOARCH
  mkdir -p $TARGET_FOLDER
  mv client.exe $TARGET_FOLDER
  mv server.exe $TARGET_FOLDER
  echo "\t Compressing Files..."
  zip -r $GOBIN/$GOOS.zip $GOBIN/$GOOS

  echo "Build for Linux..."
  GOOS="linux"
  echo "\t ix86.."
  GOARCH="386"
  echo -e "\t \t Building Server..."
  env GOOS=$GOOS GOARCH=$GOARCH go build server.go
  echo -e "\t \t Building Client..."
  env GOOS=$GOOS GOARCH=$GOARCH go build client.go
  TARGET_FOLDER=$GOBIN/$GOOS/$GOARCH
  mkdir -p $TARGET_FOLDER
  mv client $TARGET_FOLDER
  mv server $TARGET_FOLDER
  echo "\t x86_64.."
  GOARCH="amd64"
  echo -e "\t \t Building Server..."
  env GOOS=$GOOS GOARCH=$GOARCH go build server.go
  echo -e "\t \t Building Client..."
  env GOOS=$GOOS GOARCH=$GOARCH go build client.go
  TARGET_FOLDER=$GOBIN/$GOOS/$GOARCH
  mkdir -p $TARGET_FOLDER
  mv client $TARGET_FOLDER
  mv server $TARGET_FOLDER
  echo "\t Compressing Files..."
  zip -r $GOBIN/$GOOS.zip $GOBIN/$GOOS

  echo "Build for MacOS..."
  GOOS="darwin"
  echo "\t ix86.."
  GOARCH="386"
  echo -e "\t \t Building Server..."
  env GOOS=$GOOS GOARCH=$GOARCH go build server.go
  echo -e "\t \t Building Client..."
  env GOOS=$GOOS GOARCH=$GOARCH go build client.go
  TARGET_FOLDER=$GOBIN/$GOOS/$GOARCH
  mkdir -p $TARGET_FOLDER
  mv client $TARGET_FOLDER
  mv server $TARGET_FOLDER
  echo "\t x86_64.."
  GOARCH="amd64"
  echo -e "\t \t Building Server..."
  env GOOS=$GOOS GOARCH=$GOARCH go build server.go
  echo -e "\t \t Building Client..."
  env GOOS=$GOOS GOARCH=$GOARCH go build client.go
  TARGET_FOLDER=$GOBIN/$GOOS/$GOARCH
  mkdir -p $TARGET_FOLDER
  mv client $TARGET_FOLDER
  mv server $TARGET_FOLDER
  echo "\tCompressing Files..."
  zip -r $GOBIN/$GOOS.zip $GOBIN/$GOOS
fi

  echo "Build Finished."
