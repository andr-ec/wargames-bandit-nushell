# Level 05 validation
# Find file with specific properties: human-readable, 1033 bytes, not executable
# Reference: install.sh lines 188-230

export def "main check" [expected_password: string] {
    let folder = "inhere"

    if not ($folder | path exists) {
        return { success: false, message: "inhere directory not found" }
    }

    # Find all files recursively in inhere
    let files = (glob $"($folder)/**/*" | where { |f| ($f | path type) == "file" })

    if ($files | length) == 0 {
        return { success: false, message: "No files found in inhere directory" }
    }

    # Check each file for target properties
    for file in $files {
        # Check file size (1033 bytes)
        let size = (ls $file | get size | first | into int)
        if $size != 1033 {
            continue
        }

        # Check if executable (should NOT be)
        let mode = (ls -l $file | get mode | first)
        if ($mode | str contains "x") {
            continue
        }

        # Try to read as text (human-readable check)
        try {
            let content = (open $file | str trim)
            if ($content | str contains $expected_password) {
                return { success: true, message: $"Password found in ($file)!" }
            }
        } catch {
            # File is binary/not readable, skip it
            continue
        }
    }

    { success: false, message: "No file with all required properties found" }
}
