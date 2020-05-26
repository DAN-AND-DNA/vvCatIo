module vvcatio


struct vvConn {
pub mut:
    fd int
    ip string
}

struct vvEvents {
pub:
    serving fn(conn *vvConn) int
}


struct vvServer {
pub mut:
    sfd int
}
