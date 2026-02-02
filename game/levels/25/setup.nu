#!/usr/bin/env nu
# Level 25 setup
# Create SSH daemon and pincode listener on port 30002

export def "main setup" [] {
    let bandit25_password = "p7LtJwPWdt3mvKVfFMf7g67zmICG9Vy"
    let pincode = "2189"

    # Create bandit_pass directory and files
    mkdir /home/andre/Documents/scratch/bandit-wargame/bandit_pass
    echo $bandit25_password | save -f /home/andre/Documents/scratch/bandit-wargame/bandit_pass/bandit25
    echo $pincode | save -f /home/andre/Documents/scratch/bandit-wargame/bandit_pass/bandit25pin

    # Set permissions for password files
    chmod 400 /home/andre/Documents/scratch/bandit-wargame/bandit_pass/bandit25
    chmod 400 /home/andre/Documents/scratch/bandit-wargame/bandit_pass/bandit25pin

    echo $"Created level 25 with password: $bandit25_password"

    { success: true, message: $"Level 25 setup complete" }
}
