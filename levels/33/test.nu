#!/usr/bin/env nu
# Level 33 test

export def "main test" [] {
    let expected_password = "yD1jt6XZ12n4ZFGk7tXhS4Q14PveE4G8"

    # Run check
    let result = main check $expected_password

    return $result
}
