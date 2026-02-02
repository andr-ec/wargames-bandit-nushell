#!/usr/bin/env nu
# Level 33 setup
# Password stored in environment variable in .profile

export def "main setup" [] {
    let bandit33_password = "yD1jt6XZ12n4ZFGk7tXhS4Q14PveE4G8"
    let bandit34_password = "YwqW5htvZ2sDG1vMV96YQz3dALDlIJ0H"

    echo $"Created level 33 with password: $bandit33_password"

    # Create user
    sudo useradd --create-home --shell /bin/bash --home-dir /home/bandit33 bandit33

    # Set password using passwd command
    echo $bandit33_password | sudo passwd --stdin bandit33

    # Add export to .profile
    echo "export bandit34=$bandit34_password" | sudo tee /home/bandit33/.profile > /dev/null
    
    # Add the shell escape hack (profile2 trick)
    echo "head -n 4 /home/bandit33/.profile > /home/bandit33/profile2" | sudo tee -a /home/bandit33/.profile > /dev/null
    echo "mv /home/bandit33/profile2 /home/bandit33/.profile" | sudo tee -a /home/bandit33/.profile > /dev/null

    # Set correct ownership and permissions
    sudo chown bandit33:bandit33 /home/bandit33/.profile
    sudo chmod 744 /home/bandit33/.profile

    { success: true, message: $"Level 33 setup complete" }
}
