#!/usr/bin/env nu
# Level 22 validation
# Test that cron job and MD5-based password storage are properly configured

export def "main check" [expected_password: string] -> record {
    # Check cron job file exists
    let cron_file = "/etc/cron.d/cronjob_bandit23"
    if not ($cron_file | path exists) {
        return { success: false, message: "Cron job file not found" }
    }

    # Check script exists
    let script_file = "/usr/bin/cronjob_bandit23.sh"
    if not ($script_file | path exists) {
        return { success: false, message: "Script not found" }
    }

    # Check bandit_pass files exist
    let bandit_pass_path = "/home/andre/Documents/scratch/bandit-wargame/bandit_pass"
    if not ($bandit_pass_path | path exists) {
        return { success: false, message: "bandit_pass directory not found" }
    }

    if not ((bandit_pass_path / bandit22) | path exists) {
        return { success: false, message: "bandit22 password file not found" }
    }

    if not ((bandit_pass_path / bandit23) | path exists) {
        return { success: false, message: "bandit23 password file not found" }
    }

    # Check password matches
    let current_password = (open bandit_pass_path/bandit22 | str trim)

    if $current_password != $expected_password {
        return { success: false, message: $"bandit22 password mismatch: got '$current_password', expected '$expected_password'" }
    }

    # Check script has correct permissions (750 = rwxr-x---)
    let perms = (stat $script_file | get mode)

    if not ($perms | str contains "rwxr-x---") {
        return { success: false, message: $"Incorrect permissions: $perms" }
    }

    # Check cron file has correct content
    let cron_content = open -r $cron_file
    if not ($cron_content | str contains "bandit23 /usr/bin/cronjob_bandit23.sh") {
        return { success: false, message: "Cron job not properly configured" }
    }

    # Check that script has MD5 mechanism
    let script_content = open -r $script_file
    if not ($script_content | str contains "md5sum") {
        return { success: false, message: "Script does not contain MD5 mechanism" }
    }

    # Check that script uses whoami
    if not ($script_content | str contains "whoami") {
        return { success: false, message: "Script does not use whoami" }
    }

    return { success: true, message: "Level 22 setup complete" }
}
