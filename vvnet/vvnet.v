module vvnet

import net

#flag -I ./internal_c

#include "vvnet.h"
#include "vvnet.c"

#include <netinet/tcp.h>

pub struct CatServer {
    socket net.Socket
mut:
    fd int
}

fn C.set_nonblock(sfd int) int


pub fn new_server(port int, backlog int) ?CatServer {
    s := net.new_socket(C.AF_INET, C.SOCK_STREAM, 0) or {
        return error(err)
    } 

    one := 1
    s.setsockopt(C.IPPROTO_TCP, C.TCP_NODELAY, &one) or {
        return error(err)
    }

    _ = s.bind(port) or {
        return error(err)
    }

    _ = s.listen_backlog(backlog) or {
        return error(err)
    }

    if s.sockfd <= 0 {
        return error("bad server fd")
    }

    cs := CatServer {
        socket: s
        fd: s.sockfd
    }

    return cs
}


pub fn (mut this CatServer) close() ?int {
    this.fd = -1
    return this.socket.close()
}


pub fn (this CatServer) accept() ?net.Socket {
    if this.fd <= 0 {
        return error("bad server fd")
    }

    cs := this.socket.accept() or {
        return error(err)
    }

    if C.set_nonblock(cs.sockfd) < 0 {
        return error("set no block failed")
    }

    return cs
}
