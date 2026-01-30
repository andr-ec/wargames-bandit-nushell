# Check script for level 0
# Validate that player found the password in readme file

export def "main check" [expected_password: string] -> record {
    try {
        let actual_password = open readme
        check main check "bandit0" $actual_password
    } catch { |e|
        { success: false, message: $"Could not read readme file: ($e.msg)" }
    }
}
