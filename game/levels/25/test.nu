# Level 25 test

export def "main test" [] {
    let expected_password = "p7LtJwPWdt3mvKVfFMf7g67zmICG9Vy"

    # Run check
    let result = main check $expected_password

    return $result
}
