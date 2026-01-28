# Level 1 Setup
# Create readme file in bandit1 home directory
export def run-setup [] {
    use lib/game.nu

    # Set password for bandit1
    let bandit1_password = (generate-password-random)

    # Create bandit1 user
    create-user "bandit1" $bandit1_password

    # Create readme file with the password
    create-readme (path expand ~)/bandit1/readme $bandit1_password

    echo $"Password for bandit1: ($bandit1_password)"
    return $bandit1_password
}

export def run-check [input: string] {
    # We need to read the password from the readme file
    let password = open (path expand ~)/bandit1/readme | str trim
    validate-password $input $password
}
