module vvpoller

#flag -I @VROOT/internal_c/vvpoller
#flag @VROOT/internal_c/vvpoller/vvpoller.o
#include "vvpoller.h"
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
//fn C.close() int //FIXME redefinition bug of v0.1.27
fn C.close_fd() int
fn C.epoll_wait() int
fn C.epoll_ctl() int


