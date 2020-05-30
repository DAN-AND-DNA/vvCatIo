import vvnet

fn test_new_server() {
    s := vvnet.new_server(7777, 128) or {
        panic(err)
    }

    c := s.accept() or {
        panic(err)
    }

    _ = c

    s.close() or {
        panic(err)
    }
}


