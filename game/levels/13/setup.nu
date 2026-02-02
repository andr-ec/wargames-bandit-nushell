# Level 13 setup
# Generate SSH key pair

export def "main setup" [] {
    let password = "BfMYroe26WYyilR17jCw3lNAh8vY3rTZ"

    # Generate SSH key pair
    ssh-keygen -q -f sshkey.private -N "" 1>/dev/null 2>/dev/null

    # Store the password for later use
    echo $password | save -f bandit_pass.txt

    # Set proper permissions
    chmod 600 sshkey.private

    echo $"Created level 13 with password: $password"

    { success: true, message: $"Level 13 setup complete" }
}
