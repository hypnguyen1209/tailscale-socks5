package main

import (
	"flag"
	"fmt"
	"log"
	"os"

	"github.com/things-go/go-socks5"
)

func main() {
	port := flag.String("p", ":1080", "Listen address port open socks5 proxy server (example: :1080)")
	flag.Parse()
	fmt.Println("Listening on port", *port)
	server := socks5.NewServer(
		socks5.WithLogger(socks5.NewLogger(log.New(os.Stdout, "socks5: ", log.LstdFlags))),
	)
	if err := server.ListenAndServe("tcp", *port); err != nil {
		panic(err)
	}
}
