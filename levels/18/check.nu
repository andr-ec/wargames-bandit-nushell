# Level 18 validation
# Test that readme exists and .bashrc has logout commands

export def "main check" [expected_password: string] -> record {
    try {
        # Check readme exists and has content
        if not (readme)| path exists {
            return { success: false, message: "readme file not found" }
        }

        let current_password = (open readme | str trim)

        if $current_password != $expected_password {
            return { success: false, message: $"readme password mismatch: got '$current_password', expected '$expected_password'" }
        }

        # Check .bashrc exists
        if not (.bashrc)| path exists {
            return { success: false, message: ".bashrc file not found" }
        }

        # Check .bashrc has logout commands
        let bashrc_content = (open .bashrc)

        if not ($bashrc_content | str contains "Byebye!") {
            return { success: false, message: ".bashrc missing 'Byebye!' command" }
        }

        if not ($bashrc_content | str contains "exit 0") {
            return { success: false, message: ".bashrc missing 'exit 0' command" }
        }

        # Check bandit_pass files exist
        if not (bandit_pass/bandit18)| path exists {
            return { success: false, message: "bandit18 password file not found" }
        }

        if not (bandit_pass/bandit19)| path exists {
            return { success: false, message: "bandit19 password file not found" }
        }

        return { success: true, message: "Level 18 setup complete" }
    } catch {
        return { success: false, message: $"Error: ($in.message)" }
    }
}
