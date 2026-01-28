# Level 2 Check
# Read password from the hyphen-named file and validate
export def check-password [input: string] {
    use lib/check.nu

    try {
        let password = open (path expand ~)/bandit2/-- | str trim
        validate-password $input $password
    } catch {
        {
            success: false,
            message: "Error reading password file: file named '-' not found"
        }
    }
}
