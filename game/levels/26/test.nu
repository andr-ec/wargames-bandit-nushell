# Level 26 test

export def "main test" [] {
    let expected_password = "42WbmEO4SR7mvSp1E1pRK91d5FVBQwYt"

    # Run check
    let result = main check $expected_password

    return $result
}
