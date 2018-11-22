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

if [ "$1" == "-a" ]; then
  if [$# -eq 1]; then
    echo -e "You need to passa the file that will be built"
    exit 1
  fi
  BUILD_FOR_ALL="true"
  GO_FILE=$2
fi

if [ "$1" == "--all" ]; then
  if [$# -eq 1]; then
    echo -e "You need to passa the file that will be built"
    exit 1
  fi
  BUILD_FOR_ALL="true"
  GO_FILE=$2
fi

if [ "$2" == "-a" ]; then
  if [$# -eq 1]; then
    echo -e "You need to passa the file that will be built"
    exit 1
  fi
  BUILD_FOR_ALL="true"
  GO_FILE=$1
fi

if [ "$2" == "--all" ]; then
  if [$# -eq 1]; then
    echo -e "You need to passa the file that will be built"
    exit 1
  fi
  BUILD_FOR_ALL="true"
  GO_FILE=$1
fi

echo "Starting Build..."

#Polyfill for MacOsX
realpath() {
  [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

if ["$BUILD_FOR_ALL" == ""]; then
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

  echo "Building Server..."
  env GOOS=$GOOS GOARCH=$GOARCH go build -v server.go
  echo "Building Client..."
  env GOOS=$GOOS GOARCH=$GOARCH go build -v client.go
  mkdir $GOBIN/$OSTYPE
  mv client $GOBIN/$OSTYPE
  mv server $GOBIN/$OSTYPE
  echo "Compressing Files..."
  zip -r $GOBIN/$OSTYPE.zip $GOBIN/$OSTYPE
fi


echo "Build Finished."
