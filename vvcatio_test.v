import vvcatio

fn test_new_catsocket() {
    vvcatio.new_catsocket(C.AF_INET, C.SOCK_STREAM, 0) or {
        assert false
    }
}

fn test_close_catsocket() {
    cs := vvcatio.new_catsocket(C.AF_INET, C.SOCK_STREAM, 0) or {
        panic(err)
    }

    cs.close() or {
        assert false
    }
}
