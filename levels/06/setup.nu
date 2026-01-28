# Level 06 setup
# Create file in /var/lib/dpkg/info/ with specific ownership

export def "main setup" [] {
    let password = "bandit7"
    let folder = "/var/lib/dpkg/info"
    let filename = "bandit7.password"
    let filepath = ($folder | path join $filename)
    
    # Create the directory if it doesn't exist
    mkdir -p $folder
    
    # Create the file with the password
    echo $password | save -f $filepath
    
    # Set ownership to bandit7 (owner) and bandit6 (group)
    chown bandit7:bandit6 $filepath
    chmod 640 $filepath
    
    echo $"Created file $filepath with password: $password"
    
    { success: true, message: $"Level 6 setup complete" }
}
