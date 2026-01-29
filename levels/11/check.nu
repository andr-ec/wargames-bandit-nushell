# Level 11 validation
# Decode ROT13 to find password

export def "main check" [expected_password: string] -> record {
    try {
        if not (data.txt | path exists) {
            return { success: false, message: "data.txt not found" }
        }

        # Read the file and decode ROT13
        let content = (open data.txt | decode -r 13)

        # Extract password from decoded string
        let password = ($content | str trim | parse "The password is {name}" | get name.0)

        # Find password in content
        if $content | str contains $expected_password {
            return { success: true, message: "Password found after ROT13 decoding!" }
        }

        return { success: false, message: "Password not found in decoded data" }
    } catch {
        return { success: false, message: $"Error checking file: ($in.message)" }
    }
}
