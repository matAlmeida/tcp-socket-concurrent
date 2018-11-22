package main

import (
	"bufio"
	"flag"
	"fmt"
	"log"
	"net"
	"strings"
)

var (
	messages []string
	port     string
)

func main() {
	flag.StringVar(&port, "P", "8081", "port that will be used for the server.")
	flag.Parse()

	PORT := ":" + port
	fmt.Println("Lauching Server at localhost:" + port + " ...")
	ln, err := net.Listen("tcp", PORT)
	if err != nil {
		log.Fatal(err)
	}
	defer ln.Close()

	for {
		conn, err := ln.Accept()
		if err != nil {
			log.Fatal(err)
		}

		go func(c net.Conn) {
			log.Print(c.RemoteAddr().String(), " - ", "CONNECTED", " - ", "", " - ", "")
			for {
				message, _ := bufio.NewReader(c).ReadString('\n')
				recvmessage := strings.Split(message, "~")
				command := strings.Replace(recvmessage[0], "\n", "", -1)
				if len(recvmessage) > 1 {
					command = strings.Join(recvmessage[:1], "")
				}

				msgToSend := ""
				if command == "send" {
					newMessage := strings.Join(recvmessage[1:], "")
					messages = append(messages, newMessage)
					msgToSend = "Message stored 🔥\n"
					c.Write([]byte(msgToSend))

				} else if command == "get" {
					if len(messages) > 0 {
						msgToSend = messages[len(messages)-1]
						messages = messages[:len(messages)-1]
						c.Write([]byte(msgToSend))
					} else {
						msgToSend = "We hasn't any message stored!\n"
						c.Write([]byte(msgToSend))
					}

				} else if command == "exit" {
					msgToSend = "Bye Bye\n"
					log.Print(c.RemoteAddr().String(), " - ", strings.ToUpper(command), " - ", strings.Replace(strings.Join(recvmessage[1:], ""), "\n", "", -1), " - ", strings.Replace(msgToSend, "\n", "", -1))
					c.Write([]byte(msgToSend))
					break

				} else {
					msgToSend = "Invalid command\n"
					c.Write([]byte(msgToSend))

				}
				log.Print(c.RemoteAddr().String(), " - ", strings.ToUpper(command), " - ", strings.Replace(strings.Join(recvmessage[1:], ""), "\n", "", -1), " - ", strings.Replace(msgToSend, "\n", "", -1))
			}
			c.Close()
		}(conn)
	}
}
