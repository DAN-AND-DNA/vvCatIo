module vvevents

#include <sys/epoll.h>
#include <unistd.h>

struct C.epoll_event

fn C.epoll_create1(flags int) int
fn C.close(fileds int) int

struct CatEvent {
mut:
    e C.epoll_event
}

pub struct CatChannel {
    efd int
    //epoll_event_list [] &C.epoll_event
    epoll_event_list [] &CatEvent
}

pub struct CatPoller {
    stop bool
mut:
    channels [] &CatChannel
    sfd int
    tfd int
}

pub fn new_channel(length int) ?CatChannel {
    efd := C.epoll_create1(C.EPOLL_CLOEXEC)
    if efd < 0 {
        return error("epoll create failed")
    }

    mut epoll_event_list := [] &CatEvent{}

    for i := 0; i < length; i ++{
        epoll_event_list << &CatEvent{e: C.epoll_event{} }
    }

    cc := CatChannel {
        efd: efd
        epoll_event_list: epoll_event_list
        //epoll_event_list: [] &C.epoll_event { len: length, init: &C.epoll_event{} }
    }

    return cc
}

pub fn (mut this CatChannel) close() ?int {
    if this.efd <= 0 {
        return error("invalid epoll fd")
    }

    if this.efd > 0 {
        if C.close(this.efd) < 0 {
            return error("close epoll fd failed")
        }
    }

    return 0
}

pub fn new_poller(length int) ?CatPoller {
    if length < 0 {
        return error("length should bigger than zero")
    }

    mut channels := [] &CatChannel{}

    for i := 0; i < length; i++ {
        cc := new_channel(length) or {
            return error(err)
        }
        channels << &cc
    }

    cp := CatPoller {
        stop: false
        channels: channels
        sfd: -1
        tfd: -1
    }

    return cp
}

pub fn (mut this CatPoller) close() ?int {
    for cc in this.channels {
        cc.close() or {
            return error(err)    
        }
    }

    return 0
}
