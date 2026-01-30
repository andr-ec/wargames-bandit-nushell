#!/usr/bin/env nu
# Level 32 validation
# Test that bandit32 user, password file, and proper permissions are set

export def "main check" [expected_password: string] -> record {
    try {
        # Check bandit_pass directory exists
        let bandit_pass_path = "/home/bandit32/bandit_pass"
        if not ($bandit_pass_path | path exists) {
            return { success: false, message: "bandit32 password file not found" }
        }

        # Check password matches
        let current_password = (open $bandit_pass_path | str trim)

        if $current_password != $expected_password {
            return { success: false, message: $"bandit32 password mismatch: got '$current_password', expected '$expected_password'" }
        }

        # Check bandit32 user exists
        if not ((run -n "id bandit32" | str trim | str contains "bandit32")) {
            return { success: false, message: "bandit32 user not found" }
        }

        # Check correct permissions (640)
        let file_perms = (ls $bandit_pass_path | get Permissions)
        if not ($file_perms | str contains "-rw-r-----") {
            return { success: false, message: "Incorrect permissions on bandit_pass" }
        }

        # Check file is owned by bandit32
        let file_owner = (ls $bandit_pass_path | get Owner)
        if not ($file_owner | str contains "bandit32") {
            return { success: false, message: "File not owned by bandit32" }
        }

        return { success: true, message: "Level 32 setup complete" }
    } catch {
        return { success: false, message: $"Test error: ($in.message)" }
    }
}
