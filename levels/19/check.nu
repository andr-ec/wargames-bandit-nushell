# Level 19 validation
# Test that setuid binary exists with correct permissions

export def "main check" [expected_password: string] -> record {
    try {
        # Check binary exists
        if not ((path exists bandit20-do)) {
            return { success: false, message: "bandit20-do binary not found" }
        }

        # Check bandit_pass files exist
        if not ((path exists bandit_pass/bandit19)) {
            return { success: false, message: "bandit19 password file not found" }
        }

        if not ((path exists bandit_pass/bandit20)) {
            return { success: false, message: "bandit20 password file not found" }
        }

        # Check password matches
        let current_password = (open bandit_pass/bandit19 | str trim)

        if $current_password != $expected_password {
            return { success: false, message: $"bandit19 password mismatch: got '$current_password', expected '$expected_password'" }
        }

        # Check permissions (4750 = -rwsr-x---)
        let perms = (stat bandit20-do | get mode)

        # SUID bit is set (4 in permissions)
        if ($perms | str contains "-rws") {
            # Group is bandit19 (5 = r-x)
            if not ($perms | str contains "r-x--") {
                return { success: false, message: $"Incorrect group permissions: $perms" }
            }

            # Owner is bandit20 (7 = rwx)
            if not ($perms | str contains "rwx---") {
                return { success: false, message: $"Incorrect owner permissions: $perms" }
            }

            # Check owner
            let stat_result = (stat bandit20-do)
            let owner = ($stat_result | get owner)

            if $owner != "bandit20" {
                return { success: false, message: $"Incorrect owner: $owner (expected bandit20)" }
            }

            # Check group
            let group = ($stat_result | get group)

            if $group != "bandit19" {
                return { success: false, message: $"Incorrect group: $group (expected bandit19)" }
            }

            return { success: true, message: "Level 19 setup complete" }
        }

        return { success: false, message: $"SUID bit not set: $perms" }
    } catch {
        return { success: false, message: $"Error: ($in.message)" }
    }
}
