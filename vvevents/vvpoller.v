module vvevents

import os

#include <sys/epoll.h>
#include <unistd.h>
#include <errno.h>



struct C.epoll_event

fn C.epoll_create1() int
fn C.close() int
fn C.epoll_wait() int

fn error_code() int {
    return C.errno
}

pub struct CatChannel {
    efd int
    epoll_event_list &C.epoll_event
}

pub struct CatPoller {
    stop bool
mut:
    channel CatChannel
    sfd int
    tfd int
}

pub fn new_channel(length int) ?CatChannel {
    efd := C.epoll_create1(C.EPOLL_CLOEXEC)
    if efd < 0 {
        return error("epoll create failed")
    }

    mut p := byteptr(0)

    unsafe {
        p = malloc(length * sizeof(C.epoll_event))
    }

    

    cc := CatChannel {
        efd: efd
        epoll_event_list: &C.epoll_event(p)
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

    defer {
        unsafe {
            free(this.epoll_event_list)
        }
    }

    return 0
}

pub fn new_poller(length int) ?CatPoller {
    if length < 0 {
        return error("length should bigger than zero")
    }


    channel := new_channel(length) or {
        return error(err)
    }

    cp := CatPoller {
        stop: false
        channel: channel
        sfd: -1
        tfd: -1
    }

    return cp
}

pub fn (mut this CatPoller) close() ?int {
    return this.channel.close()
}

pub fn (mut this CatPoller) poll(max int) ?int {
    efd := this.channel.efd
    fired := C.epoll_wait(efd, this.channel.epoll_event_list, max, 10000)
    if fired < 0 {
        error_message := os.get_error_msg(error_code())
        return error("epoll wait failed: $error_message")
    }

    return fired
}
