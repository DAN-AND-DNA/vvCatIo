import vvevents

fn test_channel() {
    cc := vvevents.new_channel(1) or {
        panic(err)
    }

    cc.close() or {
        assert false
    }

}

fn test_poller () {
    cp := vvevents.new_poller(10) or {
        panic(err)
    }

    cp.poll(10) or {
        println(err)
        assert false
    }

    cp.close() or {
        assert false
    }

}

