# Level 29 test

export def "main test" [] {
    let expected_password = "ba4e105caeed5e19e973425fe1b0015b"

    # Run check
    let result = main check $expected_password

    return $result
}
