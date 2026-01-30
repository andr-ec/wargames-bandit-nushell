# Check script for level 1
# Validate that player found the password in file "-"

export def "main check" [expected_password: string] -> record {
    try {
        let actual_password = open "-"
        check main check "bandit1" $actual_password
    } catch { |e|
        { success: false, message: $"Could not read file '-' or file not found: ($e.msg)" }
    }
}
