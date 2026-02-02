#!/usr/bin/env nu
# Level 21 validation
# Test that cron job and temporary file mechanism are properly configured

export def "main check" [expected_password: string] {
    # Check cron job file exists
    let cron_file = "/etc/cron.d/cronjob_bandit22"
    if not ($cron_file | path exists) {
        return { success: false, message: "Cron job file not found" }
    }

    # Check script exists
    let script_file = "/usr/bin/cronjob_bandit22.sh"
    if not ($script_file | path exists) {
        return { success: false, message: "Script not found" }
    }

    # Check bandit_pass files exist
    let bandit_pass_path = "/home/andre/Documents/scratch/bandit-wargame/bandit_pass"
    if not ($bandit_pass_path | path exists) {
        return { success: false, message: "bandit_pass directory not found" }
    }

    if not ((bandit_pass_path / bandit21) | path exists) {
        return { success: false, message: "bandit21 password file not found" }
    }

    if not ((bandit_pass_path / bandit22) | path exists) {
        return { success: false, message: "bandit22 password file not found" }
    }

    # Check password matches
    let current_password = (open bandit_pass_path/bandit21 | str trim)

    if $current_password != $expected_password {
        return { success: false, message: $"bandit21 password mismatch: got '$current_password', expected '$expected_password'" }
    }

    # Check script has correct permissions (750 = rwxr-x---)
    let perms = (stat $script_file | get mode)

    if not ($perms | str contains "rwxr-x---") {
        return { success: false, message: $"Incorrect permissions: $perms" }
    }

    # Check cron file has correct content
    let cron_content = open -r $cron_file
    if not ($cron_content | str contains "bandit22 /usr/bin/cronjob_bandit22.sh") {
        return { success: false, message: "Cron job not properly configured" }
    }

    # Check that temporary file mechanism is in place
    let script_content = open -r $script_file
    if not ($script_content | str contains "tmp_file") {
        return { success: false, message: "Script does not have temporary file mechanism" }
    }

    return { success: true, message: "Level 21 setup complete" }
}
