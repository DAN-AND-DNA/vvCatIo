import vvevents

fn test_channel() {
    cc := vvevents.new_channel(1) or {
        panic(err)
    }

    cc.close() or {
        assert false
    }

    cc1 := vvevents.CatChannel{}

    cc1.close() or {
        assert true
    }
}

fn test_poller () {
    cp := vvevents.new_poller(1) or {
        panic(err)
    }

    cp.close() or {
        assert false
    }

    // test null
    cp1 := vvevents.CatPoller{}

    cp1.close() or {
        assert false
    }
}

