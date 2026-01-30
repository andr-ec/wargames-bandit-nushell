#!/usr/bin/env nu
# Level 39 setup
# Final level - thanks for playing

export def "main setup" [] {
    let bandit39_password = "4cwYehD9pQsWt9O6YUBaXUojUaYEfeZr"

    echo $"Created level 39 with password: $bandit39_password"

    # Create user
    sudo useradd --create-home --shell /bin/bash --home-dir /home/bandit39 bandit39

    # Set password using passwd command
    echo $bandit39_password | sudo passwd --stdin bandit39

    # Create password file with correct permissions
    sudo mkdir -p /home/bandit39
    echo $bandit39_password | sudo tee /home/bandit39/bandit_pass > /dev/null
    sudo chown bandit39:bandit39 /home/bandit39/bandit_pass
    sudo chmod 640 /home/bandit39/bandit_pass

    { success: true, message: $"Level 39 setup complete - Thanks for playing!" }
}
