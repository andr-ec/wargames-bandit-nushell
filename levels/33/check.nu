#!/usr/bin/env nu
# Level 33 validation
# Test that bandit33 has correct .profile with environment variable

export def "main check" [expected_password: string] -> record {
    try {
        # Check .profile exists
        let profile_path = "/home/bandit33/.profile"
        if not ($profile_path | path exists) {
            return { success: false, message: ".profile not found" }
        }

        # Check export line exists
        let profile_content = (open $profile_path)
        if not ($profile_content | str contains "export bandit34=") {
            return { success: false, message: "export bandit34 not in .profile" }
        }

        # Check the value contains the expected password (allowing for newlines)
        if not ($profile_content | str contains $expected_password) {
            return { success: false, message: $"expected password not found in .profile" }
        }

        # Check correct permissions (744)
        let file_perms = (ls $profile_path | get Permissions)
        if not ($file_perms | str contains "-rwxr--r--") {
            return { success: false, message: "Incorrect permissions on .profile" }
        }

        return { success: true, message: "Level 33 setup complete" }
    } catch {
        return { success: false, message: $"Test error: ($in.message)" }
    }
}
