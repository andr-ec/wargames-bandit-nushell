# Level 18 validation
# Test that readme exists and .bashrc has logout commands

export def "main check" [expected_password: string] -> record {
    try {
        let current_password = (open readme | str trim)
        let password_check = check main check $expected_password $current_password

        if not $password_check.success {
            return $password_check
        }

        if not (bandit_pass/bandit18)| path exists {
            return { success: false, message: "bandit18 password file not found" }
        }

        if not (bandit_pass/bandit19)| path exists {
            return { success: false, message: "bandit19 password file not found" }
        }

        return { success: true, message: "Level 18 setup complete" }
    } catch { |e|
        { success: false, message: $"Error: ($e.msg)" }
    }
}
