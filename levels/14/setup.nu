# Level 14 setup
# Setup SSH authorized key for bandit14

export def "main setup" [] {
    let password = "8xc9jcnGj82mq291qPNq8ltlQX9i5fE1"

    # Copy the SSH private key from level 13
    cp ../13/sshkey.private sshkey.private

    # Set proper permissions
    chmod 600 sshkey.private

    echo $"Created level 14 with password: $password"

    { success: true, message: $"Level 14 setup complete" }
}
