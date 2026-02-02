#!/usr/bin/env nu
# Level 30 validation
# Test that bandit30-git repository and password file are properly configured

export def "main check" [expected_password: string] {
    try {
        # Check bandit_pass directory exists
        let bandit_pass_path = "/home/andre/Documents/scratch/bandit-wargame/bandit_pass"
        if not ($bandit_pass_path | path exists) {
            return { success: false, message: "bandit_pass directory not found" }
        }

        # Check bandit30 password file exists
        if not ((bandit_pass_path / bandit30) | path exists) {
            return { success: false, message: "bandit30 password file not found" }
        }

        # Check password matches
        let current_password = (open bandit_pass_path/bandit30 | str trim)

        if $current_password != $expected_password {
            return { success: false, message: $"bandit30 password mismatch: got '$current_password', expected '$expected_password'" }
        }

        # Check bandit30-git user exists
        if not ((run -n "id bandit30-git" | str trim | str contains "bandit30-git")) {
            return { success: false, message: "bandit30-git user not found" }
        }

        # Check git-shell is set as shell
        let shell_output = run -n $"grep -c '^bandit30-git:' /etc/passwd"
        if not ($shell_output | str trim | into int) > 0 {
            return { success: false, message: "bandit30-git shell not configured to git-shell" }
        }

        # Check repository exists
        let repo_path = "/home/bandit30-git/repo"
        if not ($repo_path | path exists) {
            return { success: false, message: "Repository not found" }
        }

        # Check packed-refs exists (contains the tag)
        let packed_refs_path = $repo_path / ".git" / "packed-refs"
        if not ($packed_refs_path | path exists) {
            return { success: false, message: "packed-refs not found" }
        }

        # Check tags can be listed
        let tags_output = run -n $"cd $repo_path && git tag"
        if not ($tags_output | str trim | str contains "secret") {
            return { success: false, message: "secret tag not found" }
        }

        # Check there's a tag (secret)
        let tag_count = ($tags_output | str trim | str collect | str trim | into int)
        if not ($tag_count | into int) > 0 {
            return { success: false, message: "No tags found" }
        }

        # Check the tag is annotated
        let tag_details = run -n $"cd $repo_path && git show secret --no-patch"
        if not ($tag_details | str trim | str contains "secret") {
            return { success: false, message: "Tag is not annotated" }
        }

        return { success: true, message: "Level 30 setup complete" }
    } catch {
        return { success: false, message: $"Test error: ($in.message)" }
    }
}
