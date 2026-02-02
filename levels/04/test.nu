# Level 04 test

export def "main test" [] {
    let expected_password = "bandit5"

    # Run check
    let result = main check $expected_password

    return $result
}
