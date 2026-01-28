# Check script for level 0
# Validate that player found the password in readme file

export def "main check" [expected_password: string] -> record {
    try {
        let actual_password = open readme
        if $expected_password == $actual_password {
            return { success: true, message: "Password is correct!" }
        } else {
            return { success: false, message: "Password is incorrect. Try again." }
        }
    } catch {
        return { success: false, message: "Could not read readme file" }
    }
}
