# Level 27 test

export def "main test" [] {
    let expected_password = "4cRGHaL3sZmxBaVyFqHgOh6dpzDvjq6n"

    # Run check
    let result = main check $expected_password

    return $result
}
