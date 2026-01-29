# Level 20 validation
# Test that TCP connect binary exists with correct permissions

export def "main check" [expected_password: string] -> record {
    try {
        # Check binary exists
        if not (suconnect)| path exists {
            return { success: false, message: "suconnect binary not found" }
        }

        # Check bandit_pass files exist
        if not (bandit_pass/bandit20)| path exists {
            return { success: false, message: "bandit20 password file not found" }
        }

        if not (bandit_pass/bandit21)| path exists {
            return { success: false, message: "bandit21 password file not found" }
        }

        # Check password matches
        let current_password = (open bandit_pass/bandit20 | str trim)

        if $current_password != $expected_password {
            return { success: false, message: $"bandit20 password mismatch: got '$current_password', expected '$expected_password'" }
        }

        # Check permissions (4750 = -rwsr-x---)
        let perms = (stat suconnect | get mode)

        # SUID bit is set (4 in permissions)
        if ($perms | str contains "-rws") {
            # Group is bandit20 (5 = r-x)
            if not ($perms | str contains "r-x--") {
                return { success: false, message: $"Incorrect group permissions: $perms" }
            }

            # Owner is bandit21 (7 = rwx)
            if not ($perms | str contains "rwx---") {
                return { success: false, message: $"Incorrect owner permissions: $perms" }
            }

            # Check owner
            let stat_result = (stat suconnect)
            let owner = ($stat_result | get owner)

            if $owner != "bandit21" {
                return { success: false, message: $"Incorrect owner: $owner (expected bandit21)" }
            }

            # Check group
            let group = ($stat_result | get group)

            if $group != "bandit20" {
                return { success: false, message: $"Incorrect group: $group (expected bandit20)" }
            }

            return { success: true, message: "Level 20 setup complete" }
        }

        return { success: false, message: $"SUID bit not set: $perms" }
    } catch {
        return { success: false, message: $"Error: ($in.message)" }
    }
}
