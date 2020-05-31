package main

import (
	"fmt"
	"net"
	"time"
)

func main() {
	conn, err := net.Dial("tcp", "192.168.0.132:7773")
	if err != nil {
		panic(err)
	}

	fmt.Println("connect successful")

	defer conn.Close()
	time.Sleep(10 * time.Second)
}
