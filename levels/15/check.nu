# Level 15 validation
# Connect to TCP listener and get password

export def "main check" [expected_password: string] {
    try {
        # Read the password file
        let password14 = open "/etc/bandit_pass/bandit14"

        # Connect to port 30000 and send password14
        let output = (echo $password14 | timeout 5 nc -w 5 localhost 30000)

        if $output | str trim == $expected_password {
            return { success: true, message: "Successfully connected to TCP listener and retrieved password!" }
        } else {
            return { success: false, message: "Connection failed or password mismatch" }
        }
    } catch {
        return { success: false, message: $"Connection error: ($in.message)" }
    }
}
