# Level 06 validation
# Find file with specific ownership: bandit7 owner, bandit6 group, 33 bytes

export def "main check" [expected_password: string] -> record {
    try {
        let target_file = "/var/lib/dpkg/info/bandit7.password"
        
        # Check if file exists
        if not ($target_file | path exists) {
            return { success: false, message: "Target file not found" }
        }
        
        # Get file info
        let file_info = stat -s $target_file
        
        # Check ownership: owner should be bandit7, group should be bandit6
        let owner = $file_info.owner
        let group = $file_info.group
        
        if $owner != "bandit7" {
            return { success: false, message: $"Owner is $owner, expected bandit7" }
        }
        
        if $group != "bandit6" {
            return { success: false, message: $"Group is $group, expected bandit6" }
        }
        
        # Check file size (33 bytes)
        let size = ($file_info.size | first)
        if $size != 33 {
            return { success: false, message: $"Size is $size bytes, expected 33" }
        }
        
        # Read password and verify
        let content = open $target_file
        if $content == $expected_password {
            return { success: true, message: "Password found with correct properties!" }
        }
        
        return { success: false, message: "File has correct properties but password doesn't match" }
    } catch {
        return { success: false, message: $"Error checking file: ($in.message)" }
    }
}
