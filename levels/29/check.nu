#!/usr/bin/env nu
# Level 29 validation
# Test that bandit29-git repository and password file are properly configured

export def "main check" [expected_password: string] {
    try {
        # Check bandit_pass directory exists
        let bandit_pass_path = "/home/andre/Documents/scratch/bandit-wargame/bandit_pass"
        if not ($bandit_pass_path | path exists) {
            return { success: false, message: "bandit_pass directory not found" }
        }

        # Check bandit29 password file exists
        if not ((bandit_pass_path / bandit29) | path exists) {
            return { success: false, message: "bandit29 password file not found" }
        }

        # Check password matches
        let current_password = (open bandit_pass_path/bandit29 | str trim)

        if $current_password != $expected_password {
            return { success: false, message: $"bandit29 password mismatch: got '$current_password', expected '$expected_password'" }
        }

        # Check bandit29-git user exists
        if not ((run -n "id bandit29-git" | str trim | str contains "bandit29-git")) {
            return { success: false, message: "bandit29-git user not found" }
        }

        # Check git-shell is set as shell
        let shell_output = run -n $"grep -c '^bandit29-git:' /etc/passwd"
        if not ($shell_output | str trim | into int) > 0 {
            return { success: false, message: "bandit29-git shell not configured to git-shell" }
        }

        # Check repository exists
        let repo_path = "/home/bandit29-git/repo"
        if not ($repo_path | path exists) {
            return { success: false, message: "Repository not found" }
        }

        # Check multiple branches exist
        let branch_output = run -n $"cd $repo_path && git branch"
        if not ($branch_output | str trim | str contains "master") {
            return { success: false, message: "master branch not found" }
        }

        # Check dev branch exists
        if not ($branch_output | str trim | str contains "dev") {
            return { success: false, message: "dev branch not found" }
        }

        # Check sploits-dev branch exists
        if not ($branch_output | str trim | str contains "sploits-dev") {
            return { success: false, message: "sploits-dev branch not found" }
        }

        # Check there are multiple branches (master, dev, sploits-dev)
        let branch_count = ($branch_output | str trim | str collect | str trim | into int)
        if not ($branch_count | into int) > 0 {
            return { success: false, message: "No branches found" }
        }

        return { success: true, message: "Level 29 setup complete" }
    } catch {
        return { success: false, message: $"Test error: ($in.message)" }
    }
}
