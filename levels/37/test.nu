#!/usr/bin/env nu
# Level 37 test

export def "main test" [] {
    let expected_password = "ALBUBUiqYsZd3tYGCAwVZNnR6cNkIgUh"

    # Run check
    let result = main check $expected_password

    return $result
}
