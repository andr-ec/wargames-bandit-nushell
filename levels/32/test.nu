#!/usr/bin/env nu
# Level 32 test

export def "main test" [] {
    let expected_password = "GYokrn9Vb14NmhzO9BKjuV6OkwS4jGp8"

    # Run check
    let result = main check $expected_password

    return $result
}
