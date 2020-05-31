#include <unistd.h>
#include "vvpoller.h"


int close_fd(int fd) {
    return close(fd);
}
