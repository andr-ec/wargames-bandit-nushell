# Level 05 validation
# Find file with specific properties: human-readable, 1033 bytes, not executable

export def "main check" [expected_password: string] -> record {
    try {
        let folder = "inhere"
        
        # Find all files in inhere directory recursively
        let files = (ls -R $folder | where name != "." | where name != "..")
        
        if ($files | length) == 0 {
            return { success: false, message: "No files found in inhere directory" }
        }
        
        # Check each file for target properties
        for $file in $files {
            let full_path = $file.name
            
            # Check file exists
            if not ($full_path | path exists) {
                continue
            }
            
            # Check file size (1033 bytes)
            let size = (stat -s $full_path | get size).0
            if $size != 1033 {
                continue
            }
            
            # Check file type (human-readable)
            let file_type = (file $full_path | get -i "Human-readable" | get -i 0)
            if $file_type == null or $file_type != "ASCII text" {
                continue
            }
            
            # Check if executable
            let perms = (stat -s $full_path | get mode).0
            if ($perms | str contains "x") {
                continue
            }
            
            # Read password and verify
            let content = open $full_path
            if $content == $expected_password {
                return { success: true, message: "Password found with correct properties!" }
            }
        }
        
        return { success: false, message: "No file with all required properties found" }
    } catch {
        return { success: false, message: $"Error checking files: ($in.message)" }
    }
}
