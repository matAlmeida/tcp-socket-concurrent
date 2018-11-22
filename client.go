package main

import (
	"bufio"
	"fmt"
	"net"
	"os"
	"strings"
)

func main() {

	// connect to this socket
	reader := bufio.NewReader(os.Stdin)
	fmt.Print("Hello to HOTLINE! What's your name? ")
	username, _ := reader.ReadString('\n')
	username = strings.Replace(username, "\n", "", -1)

	conn, _ := net.Dial("tcp", "127.0.0.1:8081")
	for {
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
}
