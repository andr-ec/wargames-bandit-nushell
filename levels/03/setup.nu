# Level 3 Setup
# Create inhere directory with hidden file ...Hiding-From-You
export def run-setup [] {
    use lib/game.nu

    # Set password for bandit3
    let bandit3_password = (generate-password-random)

    # Create bandit3 user
    create-user "bandit3" $bandit3_password

    # Create inhere directory
    create-folder (path expand ~)/bandit3/inhere

    # Create hidden file named ...Hiding-From-You
    # Note: this creates a file with a name that starts with ...
    create-hidden-file (path expand ~)/bandit3/inhere/.Hiding-From-You $bandit3_password

    echo $"Password for bandit3: ($bandit3_password)"
    return $bandit3_password
}

export def run-check [input: string] {
    # Read password from the hidden file
    let password = open (path expand ~)/bandit3/inhere/.Hiding-From-You | str trim
    validate-password $input $password
}
