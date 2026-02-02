#!/usr/bin/env nu
# Level 32 setup
# Escape from shell using environment variables

export def "main setup" [] {
    let bandit32_password = "o6E9zT0k2JiQ7lq9oznO6QJv9cTBzXwZ"
    let bandit33_password = "GYokrn9Vb14NmhzO9BKjuV6OkwS4jGp8"

    echo $"Created level 32 with password: $bandit32_password"

    # Create user
    sudo useradd --create-home --shell /bin/bash --home-dir /home/bandit32 bandit32

    # Set password using passwd command
    echo $bandit32_password | sudo passwd --stdin bandit32

    # Create password file with correct permissions
    sudo mkdir -p /home/bandit32
    echo $bandit33_password | sudo tee /home/bandit32/bandit_pass > /dev/null
    sudo chown bandit32:bandit32 /home/bandit32/bandit_pass
    sudo chmod 640 /home/bandit32/bandit_pass

    { success: true, message: $"Level 32 setup complete" }
}
