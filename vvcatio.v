module vvcatio 

import net


struct CatSocket {
pub:
    raw_socket net.Socket
}

pub fn new_catsocket(family, typ, proto int) ?CatSocket {
    rs := net.new_socket(family, typ, proto) or {
        return error(err)
    }

    s := CatSocket {
        raw_socket: rs
    }

    return s
}

pub fn (cs CatSocket) close() ?int {
    return cs.raw_socket.close()
}
