#!/usr/bin/env nu
# Level 36 setup
# Password stored in SUID find binary

export def "main setup" [] {
    let bandit36_password = "D4s3J6b2S3JbD4pD.9r8Z4eVj2C4v8q"
    let bandit37_password = "daV8r54i3Lf4z42SJvvuVvzxSTB6APIn"

    echo $"Created level 36 with password: $bandit36_password"

    # Create user
    sudo useradd --create-home --shell /bin/bash --home-dir /home/bandit36 bandit36

    # Set password using passwd command
    echo $bandit36_password | sudo passwd --stdin bandit36

    # Create password file with correct permissions
    sudo mkdir -p /home/bandit36
    echo $bandit37_password | sudo tee /home/bandit36/bandit_pass > /dev/null
    sudo chown bandit36:bandit36 /home/bandit36/bandit_pass
    sudo chmod 640 /home/bandit36/bandit_pass

    { success: true, message: $"Level 36 setup complete" }
}
