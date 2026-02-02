# Level 09 test

export def "main test" [] {
    let expected_password = "bandit10"

    # Run check
    let result = main check $expected_password

    return $result
}
