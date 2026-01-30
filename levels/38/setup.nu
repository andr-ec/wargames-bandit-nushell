#!/usr/bin/env nu
# Level 38 setup
# Password stored in readme with restricted python shell

export def "main setup" [] {
    let bandit38_password = "ALBUBUiqYsZd3tYGCAwVZNnR6cNkIgUh"
    let bandit39_password = "4cwYehD9pQsWt9O6YUBaXUojUaYEfeZr"

    echo $"Created level 38 with password: $bandit38_password"

    # Create user
    sudo useradd --create-home --shell /usr/bin/python --home-dir /home/bandit38 bandit38

    # Set password using passwd command
    echo $bandit38_password | sudo passwd --stdin bandit38

    # Create password file with correct permissions
    sudo mkdir -p /home/bandit38
    echo $bandit39_password | sudo tee /home/bandit38/bandit_pass > /dev/null
    sudo chown bandit38:bandit38 /home/bandit38/bandit_pass
    sudo chmod 640 /home/bandit38/bandit_pass

    { success: true, message: $"Level 38 setup complete" }
}
