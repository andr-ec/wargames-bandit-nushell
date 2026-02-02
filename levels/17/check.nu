# Level 17 validation
# Test that passwords.old and passwords.new exist with one line changed

export def "main check" [expected_password: string] {
    try {
        # Check passwords.old exists and has content
        if not (passwords.old)| path exists {
            return { success: false, message: "passwords.old not found" }
        }

        if not (passwords.new)| path exists {
            return { success: false, message: "passwords.new not found" }
        }

        # Check bandit_pass files exist
        if not (bandit_pass/bandit17)| path exists {
            return { success: false, message: "bandit17 password file not found" }
        }

        if not (bandit_pass/bandit18)| path exists {
            return { success: false, message: "bandit18 password file not found" }
        }

        # Check files have content
        let old_count = (open passwords.old | lines | length)
        if $old_count < 99 {
            return { success: false, message: $"passwords.old has too few lines: $old_count" }
        }

        # Check passwords match expected
        let current_password = (open bandit_pass/bandit17 | str trim)
        let current_next = (open bandit_pass/bandit18 | str trim)

        if $current_password != $expected_password {
            return { success: false, message: $"bandit17 password mismatch: got '$current_password', expected '$expected_password'" }
        }

        # Check that passwords.new has one different line
        let old_lines = (open passwords.old | lines)
        let new_lines = (open passwords.new | lines)

        let old_set = ($old_lines | uniq)
        let new_set = ($new_lines | uniq)

        let diff_count = ($old_set | is-not-in $new_set | length)

        if $diff_count == 0 {
            return { success: false, message: "passwords.old and passwords.new have the same content (no changes)" }
        }

        return { success: true, message: "Level 17 setup complete with one line changed" }
    } catch {
        return { success: false, message: $"Error: ($in.message)" }
    }
}
