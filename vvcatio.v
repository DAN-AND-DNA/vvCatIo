module vvcatio

import net
import vvnet
import vvpoller


pub enum Cat {
    ok
    close
    err
}

pub struct CatConn {
    socket net.Socket
pub mut:
    fd int
}

pub struct CatEvents {
    once int
    max int
    backlog int
pub:
    serving &fn(mut conn CatConn) Cat
    writing &fn(mut conn CatConn) Cat
    reading &fn(mut conn CatConn) Cat
}


pub struct Catio {
    server vvnet.CatServer
    poller vvpoller.CatPoller
    events CatEvents
mut:
    conns []CatConn
}

fn new_catio(events CatEvents, port int) ?Catio {
    mut once := events.once
    mut max := events.max
    mut backlog := events.backlog

    if once <= 0 {
        once = 50
    }

    if max <= 0 {
        max = 1000
    }

    if backlog <= 0 {
        backlog = 128
    }
    
    cs := vvnet.new_server(port, backlog) or {
        return error(err)
    }


    p := vvpoller.new_poller(once, max) or {
        return error(err)
    }


    c := Catio {
        server: cs
        poller: p
        events: events
        conns: []CatConn {len: max}
    }

    return c
}

fn (mut this Catio) run(once int) ?int {
    mut fds := []int {len: once}
    mut actions := []u32 {len: once}

    for {
        fired := this.poller.poll(once, fds, actions) or {
            return error(err)
        }

        for i := 0; i< fired; i++ {
            fd := fds[i]
            action := actions[i]
            _ = action
                
            if fd == this.server.fd {
                //TODO client online

                client_socket := this.server.accept() or {
                    continue
                }

                conn := CatConn {
                    socket: client_socket
                    fd: client_socket.sockfd
                }

                this.conns[conn.fd] = conn
                sf := this.events.serving
                if !isnil(sf) {
                res := sf(mut this.conns[conn.fd])

                if res == Cat.ok {
                    // TODO ok
                } else if res == Cat.close {
                    // TODO close
                } else {
                    // TODO error
                }
                }

            } else {

                println('xxxx')
                //TODO client event

            }
        }
    }

    return 0
}


pub fn serve(events CatEvents, port int) ?int {
    println("listen at $port")

    catio := new_catio(events, port) or {
        return error(err)
    }

    catio.poller.input(catio.server.fd) or {
        return error(err)
    }

    return catio.run(50)
}
