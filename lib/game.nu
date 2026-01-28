export def generate-password [length: int = 32] {
    let chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    for i in $length {
        $chars | str rotate -c $i | get 0
    }
}

export def generate-password-random [] {
    let chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    ($chars | str join | rng-random $chars | str substr 0 32)
}
