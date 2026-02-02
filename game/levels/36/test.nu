#!/usr/bin/env nu
# Level 36 test

export def "main test" [] {
    let expected_password = "daV8r54i3Lf4z42SJvvuVvzxSTB6APIn"

    # Run check
    let result = main check $expected_password

    return $result
}
