# Level 06 test

export def "main test" [] {
    let expected_password = "bandit7"

    # Run check
    let result = main check $expected_password

    return $result
}
