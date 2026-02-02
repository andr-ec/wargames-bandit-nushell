# Level 09 validation
# Find human-readable string preceded by several '=' in binary data

export def "main check" [expected_password: string] -> record {
    if not ("data.txt" | path exists) {
        return { success: false, message: "data.txt not found" }
    }

    # Extract human-readable strings from binary data
    # Try strings command, fallback to tr if not available
    let strings_output = try {
        ^strings data.txt | str trim
    } catch {
        ^bash -c "cat data.txt | tr -cd '[:print:]\\n'" | str trim
    }

    # Find lines containing the password preceded by '=' characters
    let lines = ($strings_output | lines)

    for line in $lines {
        if ($line | str contains "========") and ($line | str contains $expected_password) {
            return { success: true, message: "Found password in human-readable string!" }
        }
    }

    { success: false, message: "Password pattern not found in human-readable strings" }
}
