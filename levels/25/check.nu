# Level 25 validation
# Test that bandit25 password file exists and has correct content

export def "main check" [expected_password: string] {
    try {
        # Check bandit_pass directory exists
        let bandit_pass_path = "/home/andre/Documents/scratch/bandit-wargame/bandit_pass"
        if not ($bandit_pass_path | path exists) {
            return { success: false, message: "bandit_pass directory not found" }
        }

        # Check bandit25 password file exists
        if not ((bandit_pass_path / bandit25) | path exists) {
            return { success: false, message: "bandit25 password file not found" }
        }

        # Check password matches
        let current_password = (open bandit_pass_path/bandit25 | str trim)

        if $current_password != $expected_password {
            return { success: false, message: $"bandit25 password mismatch: got '$current_password', expected '$expected_password'" }
        }

        return { success: true, message: "Level 25 password file is correct!" }
    } catch {
        return { success: false, message: $"Test error: ($in.message)" }
    }
}
