#!/usr/bin/env nu
# Level 37 validation
# Test that bandit37 has correct password file

export def "main check" [expected_password: string] -> record {
    try {
        # Check bandit_pass directory exists
        let bandit_pass_path = "/home/bandit37/bandit_pass"
        if not ($bandit_pass_path | path exists) {
            return { success: false, message: "bandit37 password file not found" }
        }

        # Check password matches
        let current_password = (open $bandit_pass_path | str trim)

        if $current_password != $expected_password {
            return { success: false, message: $"bandit37 password mismatch: got '$current_password', expected '$expected_password'" }
        }

        # Check correct permissions (640)
        let file_perms = (ls $bandit_pass_path | get Permissions)
        if not ($file_perms | str contains "-rw-r-----") {
            return { success: false, message: "Incorrect permissions on bandit_pass" }
        }

        # Check file is owned by bandit37
        let file_owner = (ls $bandit_pass_path | get Owner)
        if not ($file_owner | str contains "bandit37") {
            return { success: false, message: "File not owned by bandit37" }
        }

        return { success: true, message: "Level 37 setup complete" }
    } catch {
        return { success: false, message: $"Test error: ($in.message)" }
    }
}
