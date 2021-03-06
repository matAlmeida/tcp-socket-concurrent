package main

import (
	"bufio"
	"flag"
	"fmt"
	"net"
	"os"
	"os/signal"
	"strings"
	"syscall"
)

var (
	port string
	host string
)

func main() {
	flag.StringVar(&port, "P", "8081", "port of the server.")
	flag.StringVar(&host, "H", "localhost", "the host of the server.")
	flag.Parse()

	// connect to this socket
	reader := bufio.NewReader(os.Stdin)
	fmt.Print("Hello to HOTLINE! What's your name? ")
	username, _ := reader.ReadString('\n')
	username = strings.Replace(username, "\n", "", -1)

	// catch ctrl+c
	var gracefulStop = make(chan os.Signal)
	signal.Notify(gracefulStop, syscall.SIGTERM)
	signal.Notify(gracefulStop, syscall.SIGINT)

	serverAddress := host + ":" + port
	conn, _ := net.Dial("tcp", serverAddress)
	for {
		go func() {
			sig := <-gracefulStop
			if sig != nil {
				// fmt.Printf("exiting%+v\n", sig)
				fmt.Fprintf(conn, "exit\n")
				message, _ := bufio.NewReader(conn).ReadString('\n')
				fmt.Print("\nHOTLINE: " + message + "\n")
				os.Exit(0)
			}
		}()

		// read in input from stdin
		fmt.Print(username + ": ")
		text, _ := reader.ReadString('\n')

		// send to socket
		fmt.Fprintf(conn, text)
		// listen for reply
		message, _ := bufio.NewReader(conn).ReadString('\n')
		fmt.Print("HOTLINE: " + message + "\n")
		if text == "exit\n" {
			conn.Close()
			os.Exit(0)
		}
	}
	conn.Close()
}
