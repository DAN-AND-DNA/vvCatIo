module vvpoller

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


