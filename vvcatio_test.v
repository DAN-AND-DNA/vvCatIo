import vvcatio
import vvnet

fn ff (mut conn vvnet.CatConn) ?int {
    println("xxx")
    return 0
}

fn test_catio() {
    events := vvcatio.new_events(ff)

    catio := vvcatio.serve(events, 7773) or {
        panic(err)
    }

    _ = catio
}
