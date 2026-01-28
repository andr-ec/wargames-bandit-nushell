# Level 9 validation
# Find human-readable string preceded by several '=' in binary data

export def "main check" [expected_password: string] -> record {
    try {
        if not (data.txt | path exists) {
            return { success: false, message: "data.txt not found" }
        }

        # Extract human-readable strings from binary data
        let strings = (open data.txt | str find -r '[a-zA-Z0-9+/= ]{20,}')

        # Find strings that match the format: ...======== <password>     ...
        let password_pattern = $"========\s{expected_password}\s+{'.{20}}"

        let matches = ($strings | where ($in | str contains $password_pattern))

        if ($matches | length) > 0 {
            return { success: true, message: "Found password in human-readable string!" }
        }

        return { success: false, message: "Password pattern not found" }
    } catch {
        return { success: false, message: $"Error checking file: ($in.message)" }
    }
}
