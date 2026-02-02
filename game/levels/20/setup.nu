# Level 20 setup
# Compile TCP connect binary with SUID and set proper permissions

export def "main setup" [] {
    let password = "6ZCoIj1WlIGIls3hVzul29GQow2mU0WZ"
    let next_password = "nZBtxyQQExQHbaS4U0sRbSftp3nXXGWp"

    # Create bandit_pass files
    if not (bandit_pass | path exists) {
        mkdir bandit_pass
    }
    echo $password | save -f bandit_pass/bandit20
    echo $next_password | save -f bandit_pass/bandit21

    # Copy the compiled binary
    cp /home/andre/Documents/scratch/bandit-wargame/scripts/20_tcp_connect suconnect
    
    # Set SUID bit (4750 = 4=r, 7=ug+x, 0=o)
    chmod 4750 /home/bandit20/suconnect
    
    # Set owner and group
    chown bandit21:bandit20 /home/bandit20/suconnect

    echo $"Created level 20 with password: $password"

    { success: true, message: $"Level 20 setup complete" }
}
