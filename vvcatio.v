module vvcatio

import vvnet
import vvpoller

struct CatEvents {

}

struct Catio {
    server vvnet.CatServer
}




pub fn serve(events CatEvents, port int) ?int {
    
    //TODO parse url

    println("listen at $port")

    cs := vvnet.new_server(port, 128) or {
        return error(err)
    }

    poller := vvpoller.new_poller(20, 1000) or {
        return error(err)
    }




}
