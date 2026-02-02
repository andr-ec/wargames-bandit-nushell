#!/usr/bin/env nu
# Level 27 validation
# Test that bandit27-git repository and password file are properly configured

export def "main check" [expected_password: string] {
    try {
        # Check bandit_pass directory exists
        let bandit_pass_path = "/home/andre/Documents/scratch/bandit-wargame/bandit_pass"
        if not ($bandit_pass_path | path exists) {
            return { success: false, message: "bandit_pass directory not found" }
        }

        # Check bandit27 password file exists
        if not ((bandit_pass_path / bandit27) | path exists) {
            return { success: false, message: "bandit27 password file not found" }
        }

        # Check password matches
        let current_password = (open bandit_pass_path/bandit27 | str trim)

        if $current_password != $expected_password {
            return { success: false, message: $"bandit27 password mismatch: got '$current_password', expected '$expected_password'" }
        }

        # Check bandit27-git user exists
        if not ((run -n "id bandit27-git" | str trim | str contains "bandit27-git")) {
            return { success: false, message: "bandit27-git user not found" }
        }

        # Check git-shell is set as shell
        let shell_output = run -n $"grep -c '^bandit27-git:' /etc/passwd"
        if not ($shell_output | str trim | into int) > 0 {
            return { success: false, message: "bandit27-git shell not configured to git-shell" }
        }

        return { success: true, message: "Level 27 setup complete" }
    } catch {
        return { success: false, message: $"Test error: ($in.message)" }
    }
}
