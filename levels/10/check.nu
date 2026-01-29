# Level 10 validation
# Decode base64 and find password in human-readable string

export def "main check" [expected_password: string] -> record {
    try {
        if not (data.txt | path exists) {
            return { success: false, message: "data.txt not found" }
        }

        # Decode base64 and find password
        let decoded = (open data.txt | decode base64)

        # Extract password from decoded string
        let password = ($decoded | str trim | parse "The password is {name}" | get name.0)

        # Find password in decoded text
        if $decoded | str contains $expected_password {
            return { success: true, message: "Password found in base64 decoded data!" }
        }

        return { success: false, message: "Password not found in decoded data" }
    } catch {
        return { success: false, message: $"Error checking file: ($in.message)" }
    }
}
