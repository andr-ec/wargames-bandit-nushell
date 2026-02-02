# Level 28 test

export def "main test" [] {
    let expected_password = "56a9d190189b0a7debe49dab5fee5c2e"

    # Run check
    let result = main check $expected_password

    return $result
}
