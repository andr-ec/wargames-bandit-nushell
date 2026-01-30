#!/usr/bin/env nu
# Level 35 test

export def "main test" [] {
    let expected_password = "D4s3J6b2S3JbD4pD.9r8Z4eVj2C4v8q"

    # Run check
    let result = main check $expected_password

    return $result
}
