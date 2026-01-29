# Level 30 test

export def "main test" [] {
    let expected_password = "jN2kgmIDVu4r94XL3CxCoVQa2BFTtDFY"

    # Run check
    let result = main check $expected_password

    return $result
}
