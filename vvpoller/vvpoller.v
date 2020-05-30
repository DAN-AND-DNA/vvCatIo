module vvpoller

import os

#include <sys/epoll.h>
#include <unistd.h>
#include <errno.h>

struct C.epoll_data_t {
mut:
    fd int
}

struct C.epoll_event {
mut:
    events u32
    data C.epoll_data_t
}

fn C.epoll_create1() int
fn C.close() int
fn C.epoll_wait() int
fn C.epoll_ctl() int

fn error_code() int {
    return C.errno
}

pub struct CatChannel {
    efd int
    epoll_event_list &C.epoll_event
}

pub struct CatAction {
mut:
    action int
}


pub struct CatPoller {
    stop bool
    sfd int
    tfd int
    max_fd int
mut:
    channel CatChannel
    actions [] CatAction
}

pub fn new_channel(length u32) ?CatChannel {
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

pub fn new_poller(length int, max_fd int) ?CatPoller {
    
    if length < 0 {
        return error("length should bigger than zero")
    }

    channel := new_channel(length) or {
        return error(err)
    }

    cp := CatPoller {
        stop: false
        max_fd: max_fd
        channel: channel
        actions: [] CatAction {len: max_fd, init: CatAction{} }
        sfd: -1
        tfd: -1
    }

    return cp
}

pub fn (this CatPoller) close() ?int {
    return this.channel.close()
}

pub fn (this CatPoller) poll(max int, mut fds []int, mut actions []u32) ?int {
    fired := C.epoll_wait(this.channel.efd, this.channel.epoll_event_list, max, 10000)
    if fired < 0 && error_code() != C.EINTR {
        error_message := os.get_error_msg(error_code())
        return error("epoll wait failed: $error_message")
    } else {
        return 0
    }

    for i :=0; i < fired; i++ {
        curr_event := this.channel.epoll_event_list[i]
        
        fds[i] = curr_event.data.fd
        actions[i] = curr_event.events
    }

    return fired
}

fn (mut this CatPoller) add(new_fd int,  action int) ? {
    if new_fd > this.max_fd {
        return error("reach max fd")
    }

    mut op := C.EPOLL_CTL_ADD
    if this.actions[new_fd].action != 0 {
        op = C.EPOLL_CTL_MOD
    }

    this.actions[new_fd].action |= action

    mut ee := C.epoll_event {}

    ee.events = u32(action)
    ee.data.fd = new_fd

    if C.epoll_ctl(this.channel.efd, op, new_fd, &ee) < 0 {
        error_message := os.get_error_msg(error_code())
        return error("epoll ctl failed: $error_message")
    }

    return none
}


pub fn (this CatPoller) input(new_fd int) ? {
    return this.add(new_fd, C.EPOLLIN)
}

pub fn (this CatPoller) output(new_fd int) ? {
    return this.add(new_fd, C.EPOLLOUT)
}

pub fn is_readable(action int)  bool {
    if action & (C.EPOLLIN | C.EPOLLPRI | C.EPOLLRDHUP)  > 0 {
        return true
    }

    return false
}

pub fn is_writeable(action int) bool {
    if action & (C.EPOLLOUT) > 0 {
        return true
    }

    return false
}
