# Level 13 validation
# Test SSH key usage

export def "main check" [expected_password: string] {
    try {
        if not (sshkey.private | path exists) {
            return { success: false, message: "sshkey.private not found" }
        }

        # Test SSH login using the private key
        let ssh_output = (ssh -i sshkey.private -o StrictHostKeyChecking=no -o ConnectTimeout=5 bandit14@localhost "cat /etc/bandit_pass/bandit15" 

        if $ssh_output == $expected_password {
            return { success: true, message: "Successfully logged in as bandit14 and retrieved password!" }
        } else {
            return { success: false, message: "SSH login failed or password mismatch" }
        }
    } catch {
        return { success: false, message: $"SSH error: ($in.message)" }
    }
}
