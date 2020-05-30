module vvnet


#flag -I @VROOT/internal_c/vvnet
#flag @VROOT/internal_c/vvnet/vvnet.o
#include "vvnet.h"
#include <netinet/tcp.h>


fn C.set_nonblock(sfd int) int
