module vvcatio

import vvnet
import vvpoller


struct CatEvents {
    serving fn(mut conn vvnet.CatConn) ?int
}


pub struct Catio {
    server vvnet.CatServer
    poller vvpoller.CatPoller
    events CatEvents
mut:
    conns []vvnet.CatConn
}


pub fn new_events(serving fn(mut conn vvnet.CatConn) ?int) CatEvents {
    return CatEvents {
        serving: serving
    }
}


fn new_catio(events CatEvents, port, once int, max int) ?Catio {
    cs := vvnet.new_server(port, 128) or {
        return error(err)
    }

    p := vvpoller.new_poller(once, max) or {
        return error(err)
    }


    c := Catio {
        server: cs
        poller: p
        events: events
    }

    return c
}

fn (mut this Catio) run(max int) ?int {
    mut fds := []int {len: max}
    mut actions := []u32 {len: max}

    for {
        fired := this.poller.poll(max, fds, actions) or {
            return error(err)
        }

        for i := 0; i< fired; i++ {
            fd := fds[i]
            action := actions[i]
            _ = action
                
            if fd == this.server.fd {

                //TODO server event

            } else {

                //TODO client event

            }
        }
    }

    return 0
}


pub fn serve(events CatEvents, port int) ?int {
    println("listen at $port")

    catio := new_catio(events, port, 20, 1000) or {
        return error(err)
    }

    return catio.run(50)
}
