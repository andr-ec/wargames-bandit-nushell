#!/usr/bin/env nu
# Level 38 validation
# Test that bandit38 has correct password file

export def "main check" [expected_password: string] {
    try {
        # Check bandit_pass directory exists
        let bandit_pass_path = "/home/bandit38/bandit_pass"
        if not ($bandit_pass_path | path exists) {
            return { success: false, message: "bandit38 password file not found" }
        }

        # Check password matches
        let current_password = (open $bandit_pass_path | str trim)

        if $current_password != $expected_password {
            return { success: false, message: $"bandit38 password mismatch: got '$current_password', expected '$expected_password'" }
        }

        # Check correct permissions (640)
        let file_perms = (ls $bandit_pass_path | get Permissions)
        if not ($file_perms | str contains "-rw-r-----") {
            return { success: false, message: "Incorrect permissions on bandit_pass" }
        }

        # Check file is owned by bandit38
        let file_owner = (ls $bandit_pass_path | get Owner)
        if not ($file_owner | str contains "bandit38") {
            return { success: false, message: "File not owned by bandit38" }
        }

        return { success: true, message: "Level 38 setup complete" }
    } catch {
        return { success: false, message: $"Test error: ($in.message)" }
    }
}
