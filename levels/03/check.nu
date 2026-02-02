# Check script for level 3
# Validate that player found the password in hidden file

export def "main check" [expected_password: string] {
    try {
        # Find the hidden file in inhere/ directory
        # Look for files starting with "..."
        let hidden_file = ls -a inhere | where name =~ "\\.\\.\\." | first
        
        if $hidden_file == null {
            return { success: false, message: "Hidden file not found" }
        }
        
        let actual_password = open ($hidden_file.name)
        if $expected_password == $actual_password {
            return { success: true, message: "Password is correct!" }
        } else {
            return { success: false, message: "Password is incorrect. Try again." }
        }
    } catch {
        return { success: false, message: "Could not read hidden file or file not found" }
    }
}
