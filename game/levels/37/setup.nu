#!/usr/bin/env nu
# Level 37 setup
# Password stored in SUID cp binary

export def "main setup" [] {
    let bandit37_password = "daV8r54i3Lf4z42SJvvuVvzxSTB6APIn"
    let bandit38_password = "ALBUBUiqYsZd3tYGCAwVZNnR6cNkIgUh"

    echo $"Created level 37 with password: $bandit37_password"

    # Create user
    sudo useradd --create-home --shell /bin/bash --home-dir /home/bandit37 bandit37

    # Set password using passwd command
    echo $bandit37_password | sudo passwd --stdin bandit37

    # Create password file with correct permissions
    sudo mkdir -p /home/bandit37
    echo $bandit38_password | sudo tee /home/bandit37/bandit_pass > /dev/null
    sudo chown bandit37:bandit37 /home/bandit37/bandit_pass
    sudo chmod 640 /home/bandit37/bandit_pass

    { success: true, message: $"Level 37 setup complete" }
}
