# Check script for level 2
# Validate that player found the password in file with spaces

export def "main check" [expected_password: string] -> record {
    try {
        # Quote the filename with spaces
        let actual_password = open "spaces in this filename"
        if $expected_password == $actual_password {
            return { success: true, message: "Password is correct!" }
        } else {
            return { success: false, message: "Password is incorrect. Try again." }
        }
    } catch {
        return { success: false, message: "Could not read file with spaces or file not found" }
    }
}
