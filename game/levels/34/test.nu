#!/usr/bin/env nu
# Level 34 test

export def "main test" [] {
    let expected_password = "IfOzZF1tsMUZ1MUDmgNCykuY7UhGWw5T"

    # Run check
    let result = main check $expected_password

    return $result
}
