#!/usr/bin/env nu
# Level 24 validation
# Test that cron job and script launcher are properly configured

export def "main check" [expected_password: string] {
    # Check cron job file exists
    let cron_file = "/etc/cron.d/cronjob_bandit25"
    if not ($cron_file | path exists) {
        return { success: false, message: "Cron job file not found" }
    }

    # Check script exists
    let script_file = "/usr/bin/cronjob_bandit24.sh"
    if not ($script_file | path exists) {
        return { success: false, message: "Script not found" }
    }

    # Check bandit_pass files exist
    let bandit_pass_path = "/home/andre/Documents/scratch/bandit-wargame/bandit_pass"
    if not ($bandit_pass_path | path exists) {
        return { success: false, message: "bandit_pass directory not found" }
    }

    if not ((bandit_pass_path / bandit24) | path exists) {
        return { success: false, message: "bandit24 password file not found" }
    }

    if not ((bandit_pass_path / bandit25) | path exists) {
        return { success: false, message: "bandit25 password file not found" }
    }

    # Check password matches
    let current_password = (open bandit_pass_path/bandit24 | str trim)

    if $current_password != $expected_password {
        return { success: false, message: $"bandit24 password mismatch: got '$current_password', expected '$expected_password'" }
    }

    # Check script has correct permissions (750 = rwxr-x---)
    let perms = (stat $script_file | get mode)

    if not ($perms | str contains "rwxr-x---") {
        return { success: false, message: $"Incorrect permissions: $perms" }
    }

    # Check cron file has correct content
    let cron_content = open -r $cron_file
    if not ($cron_content | str contains "bandit25 /usr/bin/cronjob_bandit24.sh") {
        return { success: false, message: "Cron job not properly configured" }
    }

    # Check that directory exists with correct permissions
    let dir_path = "/var/spool/bandit25/foo"
    if not ($dir_path | path exists) {
        return { success: false, message: "Directory not found" }
    }

    let dir_perms = (ls $dir_path | get Mode)
    if not ($dir_perms | str contains "rwxrwxrwx") {
        return { success: false, message: $"Incorrect directory permissions: $dir_perms" }
    }

    # Check that script references the directory
    let script_content = open -r $script_file
    if not ($script_content | str contains "/var/spool/bandit25/foo") {
        return { success: false, message: "Script does not reference correct directory" }
    }

    return { success: true, message: "Level 24 setup complete" }
}
