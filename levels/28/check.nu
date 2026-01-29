#!/usr/bin/env nu
# Level 28 validation
# Test that bandit28-git repository and password file are properly configured

export def "main check" [expected_password: string] -> record {
    try {
        # Check bandit_pass directory exists
        let bandit_pass_path = "/home/andre/Documents/scratch/bandit-wargame/bandit_pass"
        if not ($bandit_pass_path | path exists) {
            return { success: false, message: "bandit_pass directory not found" }
        }

        # Check bandit28 password file exists
        if not ((bandit_pass_path / bandit28) | path exists) {
            return { success: false, message: "bandit28 password file not found" }
        }

        # Check password matches
        let current_password = (open bandit_pass_path/bandit28 | str trim)

        if $current_password != $expected_password {
            return { success: false, message: $"bandit28 password mismatch: got '$current_password', expected '$expected_password'" }
        }

        # Check bandit28-git user exists
        if not ((run -n "id bandit28-git" | str trim | str contains "bandit28-git")) {
            return { success: false, message: "bandit28-git user not found" }
        }

        # Check git-shell is set as shell
        let shell_output = run -n $"grep -c '^bandit28-git:' /etc/passwd"
        if not ($shell_output | str trim | into int) > 0 {
            return { success: false, message: "bandit28-git shell not configured to git-shell" }
        }

        # Check repository exists
        let repo_path = "/home/bandit28-git/repo"
        if not ($repo_path | path exists) {
            return { success: false, message: "Repository not found" }
        }

        # Check it's a git repository
        if not (run -n $"cd $repo_path && git rev-parse --git-dir" | str trim | str contains ".git") {
            return { success: false, message: "Not a git repository" }
        }

        # Check there are multiple commits
        let commit_count = (run -n $"cd $repo_path && git log --oneline" | str trim | str collect)
        if not ($commit_count | str trim | into int) > 0 {
            return { success: false, message: "Repository has no commits" }
        }

        return { success: true, message: "Level 28 setup complete" }
    } catch {
        return { success: false, message: $"Test error: ($in.message)" }
    }
}
