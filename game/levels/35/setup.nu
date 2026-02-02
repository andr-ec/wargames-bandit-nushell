#!/usr/bin/env nu
# Level 35 setup
# Password stored in /usr/local/share/man/

export def "main setup" [] {
    let bandit35_password = "IfOzZF1tsMUZ1MUDmgNCykuY7UhGWw5T"
    let bandit36_password = "D4s3J6b2S3JbD4pD.9r8Z4eVj2C4v8q"

    echo $"Created level 35 with password: $bandit35_password"

    # Create user
    sudo useradd --create-home --shell /bin/bash --home-dir /home/bandit35 bandit35

    # Set password using passwd command
    echo $bandit35_password | sudo passwd --stdin bandit35

    # Create password file with correct permissions
    sudo mkdir -p /home/bandit35
    echo $bandit36_password | sudo tee /home/bandit35/bandit_pass > /dev/null
    sudo chown bandit35:bandit35 /home/bandit35/bandit_pass
    sudo chmod 640 /home/bandit35/bandit_pass

    { success: true, message: $"Level 35 setup complete" }
}
