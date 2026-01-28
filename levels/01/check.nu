# Check script for level 1
# Validate that player found the password in file "-"

export def "main check" [expected_password: string] -> record {
    try {
        # Use `open -` to read file named "-"
        let actual_password = open "-"
        if $expected_password == $actual_password {
            return { success: true, message: "Password is correct!" }
        } else {
            return { success: false, message: "Password is incorrect. Try again." }
        }
    } catch {
        return { success: false, message: "Could not read file '-' or file not found" }
    }
}
