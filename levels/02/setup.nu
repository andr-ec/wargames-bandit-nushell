# Level 2 Setup
# Create a file named - (hyphen) in bandit2 home directory
export def run-setup [] {
    use lib/game.nu

    # Set password for bandit2
    let bandit2_password = (generate-password-random)

    # Create bandit2 user
    create-user "bandit2" $bandit2_password

    # Create a file with hyphen as filename (needs special handling)
    # In bash, you can do: touch - && echo "password" > -
    # In nushell, we need to use -- or quotes
    mkdir -p (path expand ~)/bandit2
    cd (path expand ~)/bandit2
    touch -- "-"

    # Write password to the hyphen file
    echo $bandit2_password > "--"

    echo $"Password for bandit2: ($bandit2_password)"
    return $bandit2_password
}

export def run-check [input: string] {
    # Read password from the - file
    let password = open (path expand ~)/bandit2/-- | str trim
    validate-password $input $password
}
