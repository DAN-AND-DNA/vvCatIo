module vvnet

import net

pub fn new_server(port int, backlog int)  ?net.Socket {
    s := net.new_socket(C.AF_INET, C.SOCK_STREAM, 0) or {
        return error(err)
    } 

    one := 1
    _ = s.setsockopt(C.IPPROTO_TCP, C.TCP_NODELAY, &one) or {
        return error(err)
    }

    _ = s.bind(port) or {
        return error(err)
    }

    _ = s.listen_backlog(backlog) or {
        return error(err)
    }

    return s
}
