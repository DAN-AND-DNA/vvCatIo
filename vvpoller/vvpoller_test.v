import vvpoller

fn test_channel() {
    cc := vvpoller.new_channel(1) or {
        panic(err)
    }

    cc.close() or {
        assert false
    }
}

fn test_poller () {
    cp := vvpoller.new_poller(10, 1000) or {
        panic(err)
    }

    mut fds:= []int{len: 10}
    mut actions := []u32{len: 10}
    
    num := cp.poll(10, fds, actions) or {
        panic(err)
    }
    _ = num

    cp.close() or {
        panic(err)
    }
}

