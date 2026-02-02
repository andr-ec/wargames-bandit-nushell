#!/usr/bin/env nu
# Level 31 validation
# Test that bandit31-git bare repository and password file are properly configured

export def "main check" [expected_password: string] {
    try {
        # Check bandit_pass directory exists
        let bandit_pass_path = "/home/andre/Documents/scratch/bandit-wargame/bandit_pass"
        if not ($bandit_pass_path | path exists) {
            return { success: false, message: "bandit_pass directory not found" }
        }

        # Check bandit31 password file exists
        if not ((bandit_pass_path / bandit31) | path exists) {
            return { success: false, message: "bandit31 password file not found" }
        }

        # Check password matches
        let current_password = (open bandit_pass_path/bandit31 | str trim)

        if $current_password != $expected_password {
            return { success: false, message: $"bandit31 password mismatch: got '$current_password', expected '$expected_password'" }
        }

        # Check bandit31-git user exists
        if not ((run -n "id bandit31-git" | str trim | str contains "bandit31-git")) {
            return { success: false, message: "bandit31-git user not found" }
        }

        # Check git-shell is set as shell
        let shell_output = run -n $"grep -c '^bandit31-git:' /etc/passwd"
        if not ($shell_output | str trim | into int) > 0 {
            return { success: false, message: "bandit31-git shell not configured to git-shell" }
        }

        # Check bare repository exists
        let repo_path = "/home/bandit31-git/repo.git"
        if not ($repo_path | path exists) {
            return { success: false, message: "Repository not found" }
        }

        # Check it's a bare repository
        let bare_output = run -n $"cd $repo_path && git config --get core.bare"
        if not ($bare_output | str trim | str contains "true") {
            return { success: false, message: "Not a bare repository" }
        }

        # Check pre-receive hook exists
        let hook_path = $repo_path / "hooks" / "pre-receive"
        if not ($hook_path | path exists) {
            return { success: false, message: "pre-receive hook not found" }
        }

        # Check hook is executable
        let hook_perms = (ls $hook_path | get Permissions)
        if not ($hook_perms | str contains "x") {
            return { success: false, message: "Hook is not executable" }
        }

        # Check hook file exists
        if not (run -n $"test -f $hook_path && echo 'exists'" | str trim | str contains "exists") {
            return { success: false, message: "Hook file not found" }
        }

        return { success: true, message: "Level 31 setup complete" }
    } catch {
        return { success: false, message: $"Test error: ($in.message)" }
    }
}
