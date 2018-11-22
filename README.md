# TCP Socket with Concurrenc

Server and Client using TCP protocol with Concurrenc

## Building

Install [golang](https://golang.org)
Then download this packages

```sh
$ go get -v github.com/matalmeida/tcp-socket-concurrent
$ cd $GOPATH/src/github.com/matalmeida/tcp-socket-concurrent/
$ go build server.go && go build client.go
```

## Usage

### Server

```
Usage of server:
  -P string
    	port that will be used for the server. (default "8081")
```

### Client

```
Usage of client:
  -H string
    	the host of the server. (default "localhost")
  -P string
    	port of the server. (default "8081")
```

# MIT Licence
