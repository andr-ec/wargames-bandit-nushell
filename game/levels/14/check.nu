# Level 14 validation
# Test reading password file

export def "main check" [expected_password: string] {
    try {
        # Read the password file directly
        let content = open "/etc/bandit_pass/bandit14"

        if $content == $expected_password {
            return { success: true, message: "Successfully read /etc/bandit_pass/bandit14" }
        } else {
            return { success: false, message: "Password file exists but content mismatch" }
        }
    } catch {
        return { success: false, message: $"Error reading password file: ($in.message)" }
    }
}
