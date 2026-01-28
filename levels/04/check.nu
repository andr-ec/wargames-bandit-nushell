# Level 04 validation
# Find the hidden file in inhere directory and verify password

export def "main check" [expected_password: string] -> record {
    try {
        let folder = "inhere"
        
        # Find hidden files (files starting with dots)
        let hidden_files = (ls -a $folder | where name =~ "^\\." | get name)
        
        if ($hidden_files | length) == 0 {
            return { success: false, message: "No hidden files found in inhere directory" }
        }
        
        # Check each hidden file
        for $file in $hidden_files {
            let full_path = ($folder | path join $file)
            
            # Check if file exists and is readable
            if not ($full_path | path exists) {
                continue
            }
            
            let content = open $full_path
            if $content == $expected_password {
                return { success: true, message: "Password found in hidden file!" }
            }
        }
        
        return { success: false, message: "Password not found in any hidden file" }
    } catch {
        return { success: false, message: $"Error checking files: ($in.message)" }
    }
}
