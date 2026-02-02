#!/usr/bin/env nu
# Level 39 test

export def "main test" [] {
    let expected_password = "4cwYehD9pQsWt9O6YUBaXUojUaYEfeZr"

    # Run check
    let result = main check $expected_password

    return $result
}
