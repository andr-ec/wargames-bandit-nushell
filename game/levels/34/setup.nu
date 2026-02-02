#!/usr/bin/env nu
# Level 34 setup
# Password stored in recently modified file

export def "main setup" [] {
    let bandit34_password = "YwqW5htvZ2sDG1vMV96YQz3dALDlIJ0H"
    let bandit35_password = "IfOzZF1tsMUZ1MUDmgNCykuY7UhGWw5T"

    echo $"Created level 34 with password: $bandit34_password"

    # Create user
    sudo useradd --create-home --shell /bin/bash --home-dir /home/bandit34 bandit34

    # Set password using passwd command
    echo $bandit34_password | sudo passwd --stdin bandit34

    # Create password file with correct permissions
    sudo mkdir -p /home/bandit34
    echo $bandit35_password | sudo tee /home/bandit34/bandit_pass > /dev/null
    sudo chown bandit34:bandit34 /home/bandit34/bandit_pass
    sudo chmod 640 /home/bandit34/bandit_pass

    { success: true, message: $"Level 34 setup complete" }
}
