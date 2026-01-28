# Level 1 Check
# Read password from readme file and validate against input
export def check-password [input: string] {
    use lib/check.nu

    try {
        let password = open (path expand ~)/bandit1/readme | str trim
        validate-password $input $password
    } catch {
        {
            success: false,
            message: "Error reading password file: readme not found in /home/bandit1/"
        }
    }
}
