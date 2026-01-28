# Level 3 Check
# Read password from hidden file and validate
export def check-password [input: string] {
    use lib/check.nu

    try {
        let password = open (path expand ~)/bandit3/inhere/.Hiding-From-You | str trim
        validate-password $input $password
    } catch {
        {
            success: false,
            message: "Error reading password file: hidden file not found in /home/bandit3/inhere/"
        }
    }
}
