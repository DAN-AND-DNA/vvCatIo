import vvnet

fn test_new_server() {
    s := vvnet.new_server(7777, 128) or {
        panic(err)
    }

    _ = s
}
