package main

import (
	"flag"
	"io"
	"log"
	"net"
	"strings"
	"time"
)

func main() {
	local := flag.String(`l`, `127.0.0.1:1081`, `local port use forward`)
	listen := flag.String(`r`, `0.0.0.0:1080`, `remote host`)
	timeout := flag.Int(`t`, 4, `timeout to dialer`)
	flag.Parse()
	listener, err := net.Listen("tcp", *listen)
	if err != nil {
		panic(err)
	}
	for {
		src, err := listener.Accept()
		if err != nil {
			println(err.Error())
			continue
		}
		go func(src net.Conn) {
			dst, err := net.DialTimeout("tcp", *local, time.Duration(*timeout)*time.Second)
			if err != nil {
				if strings.Contains(err.Error(), "i/o timeout") {
					log.Printf(`%s <-> %s dial timeout\n`, src.RemoteAddr().String(), *local)

				} else {
					println(err.Error())
				}
				_ = src.Close()
				return
			}
			log.Printf(`%s <-> %s\n`, src.RemoteAddr().String(), *local)
			go func(src, dst net.Conn) {
				_, _ = io.Copy(src, dst)
				_ = src.Close()
				_ = dst.Close()
			}(src, dst)
			go func(src, dst net.Conn) {
				_, _ = io.Copy(dst, src)
				_ = src.Close()
				_ = dst.Close()
			}(src, dst)
		}(src)
	}
}
