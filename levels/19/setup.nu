# Level 19 setup
# Compile setuid binary and set proper permissions

export def "main setup" [] {
    let password = "Ik8waovuZeOykkk4iAv0lkq5HllJGj7z"
    let next_password = "6ZCoIj1WlIGIls3hVzul29GQow2mU0WZ"

    # Create the setuid binary (already compiled)
    # This binary allows running commands as bandit20
    # We'll create a placeholder that actually works
    
    # Create bandit_pass files
    if not (bandit_pass | path exists) {
        mkdir bandit_pass
    }
    echo $password | save -f bandit_pass/bandit19
    echo $next_password | save -f bandit_pass/bandit20

    # Copy the compiled binary
    cp /home/andre/Documents/scratch/bandit-wargame/scripts/19_suid bandit20-do
    
    # Set SUID bit (4750 = 4=r, 7=ug+x, 0=o)
    chmod 4750 /home/bandit19/bandit20-do
    
    # Set owner and group
    chown bandit20:bandit19 /home/bandit19/bandit20-do

    echo $"Created level 19 with password: $password"

    { success: true, message: $"Level 19 setup complete" }
}
