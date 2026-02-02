# Level 11 test

export def "main test" [] {
    let expected_password = "bandit12"

    # Run check
    let result = main check $expected_password

    return $result
}
