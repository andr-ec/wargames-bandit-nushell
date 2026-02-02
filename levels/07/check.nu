# Level 7 validation
# Find password next to word "millionth" in data.txt

export def "main check" [expected_password: string] {
    try {
        if not (data.txt | path exists) {
            return { success: false, message: "data.txt not found" }
        }

        # Read all lines from data.txt
        let lines = (open data.txt | lines)

        # Find the line containing "millionth"
        let millionth_line = ($lines | where ($in | str contains "millionth") | first)

        if $millionth_line == null {
            return { success: false, message: "Line with 'millionth' not found" }
        }

        # Check if line contains expected password after "millionth\t"
        let parts = ($millionth_line | str split "\t")
        if ($parts | length) >= 2 {
            let extracted = $parts | get 1
            if $extracted == $expected_password {
                return { success: true, message: "Password found next to 'millionth'!" }
            }
        }

        return { success: false, message: "Password format incorrect" }
    } catch {
        return { success: false, message: $"Error checking file: ($in.message)" }
    }
}
