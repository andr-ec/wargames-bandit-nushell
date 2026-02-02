# Level 05 test

export def "main test" [] {
    let expected_password = "bandit6"

    # Run check
    let result = main check $expected_password

    return $result
}
