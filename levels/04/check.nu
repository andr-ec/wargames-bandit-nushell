# Level 04 validation
# Find the only human-readable file in inhere directory
# Reference: install.sh lines 163-185

export def "main check" [expected_password: string] -> record {
    let folder = "inhere"

    if not ($folder | path exists) {
        return { success: false, message: "inhere directory not found" }
    }

    # Get all files in the directory
    let files = (ls $folder | where type == "file" | get name)

    if ($files | length) == 0 {
        return { success: false, message: "No files found in inhere directory" }
    }

    # Check each file for human-readable content containing the password
    for file in $files {
        try {
            let content = (open $file | str trim)
            if $content == $expected_password {
                return { success: true, message: $"Password found in human-readable file ($file)!" }
            }
        } catch {
            # File is binary/not readable as text, skip it
            continue
        }
    }

    { success: false, message: "Password not found in any human-readable file" }
}
