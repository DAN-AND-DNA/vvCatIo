#include "vvnet.h"

#include <fcntl.h>

int set_nonblock(int fd) {
    int flags = fcntl(fd, F_GETFL);

    if (flags < 0) {
        return -1;
    }

    flags |= O_NONBLOCK;

    if(fcntl(fd, F_SETFL, flags) == -1) {
        return -1;
    }
    
    return 0;
}
