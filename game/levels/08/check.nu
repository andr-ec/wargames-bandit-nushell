# Level 8 validation
# Find the only unique line in file

export def "main check" [expected_password: string] {
    try {
        if not (data.txt | path exists) {
            return { success: false, message: "data.txt not found" }
        }

        # Read all lines from data.txt
        let lines = (open data.txt | lines)

        # Count occurrences of each line
        let counts = ($lines | group-by | each { |group| {key: $group.key, count: ($group.value | length)} } | transpose key count | sort-by count)

        # Find lines with count == 1 (unique lines)
        let unique_lines = ($counts | where count == 1 | get key)

        # If we found exactly one unique line and it matches the expected password
        if ($unique_lines | length) == 1 {
            let unique_line = $unique_lines | get 0
            if $unique_line == $expected_password {
                return { success: true, message: "Found the only unique line!" }
            }
        }

        return { success: false, message: "No unique line found or doesn't match password" }
    } catch {
        return { success: false, message: $"Error checking file: ($in.message)" }
    }
}
