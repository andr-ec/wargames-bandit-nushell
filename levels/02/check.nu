# Check script for level 2
# Validate that player found the password in file with spaces

export def "main check" [expected_password: string] -> record {
    try {
        let actual_password = open "spaces in this filename"
        check main check "bandit2" $actual_password
    } catch { |e|
        { success: false, message: $"Could not read file with spaces or file not found: ($e.msg)" }
    }
}
