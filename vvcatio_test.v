import vvcatio

fn serving (mut conn vvcatio.CatConn) vvcatio.Cat {
    println("serving")
    return vvcatio.Cat.ok
}

fn writing (mut conn vvcatio.CatConn) vvcatio.Cat {
    println("writing")
    return vvcatio.Cat.ok 
}

fn reading (mut conn vvcatio.CatConn) vvcatio.Cat {
    println("reading")
    return vvcatio.Cat.ok
}

fn test_catio() {
    events := vvcatio.CatEvents {
        once: 50
        max: 1000
        serving: serving
        writing: writing
    }

    catio := vvcatio.serve(events, 7773) or {
        panic(err)
    }

    _ = catio
}
