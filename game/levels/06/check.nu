# Level 06 validation
# Find file with specific ownership: bandit7 owner, bandit6 group, 33 bytes
# Reference: install.sh lines 233-238

export def "main check" [expected_password: string] {
    # Try system path first (Docker), fallback to local for testing
    let target_file = if ("/var/lib/dpkg/info/bandit7.password" | path exists) {
        "/var/lib/dpkg/info/bandit7.password"
    } else {
        "bandit_pass/bandit7.password"
    }

    # Check if file exists
    if not ($target_file | path exists) {
        return { success: false, message: "Target file not found" }
    }

    # Check file size (should be password length, around 33 bytes or less)
    let size = (ls $target_file | get size | first | into int)
    if $size > 64 {
        return { success: false, message: $"File size ($size) is too large" }
    }

    # Read password and verify
    try {
        let content = (open $target_file | str trim)
        if $content == $expected_password {
            return { success: true, message: "Password found with correct properties!" }
        }
        { success: false, message: "File exists but password doesn't match" }
    } catch {
        { success: false, message: $"Error reading file" }
    }
}
