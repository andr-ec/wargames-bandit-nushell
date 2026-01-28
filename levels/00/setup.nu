# Setup script for level 0
# Create readme file with password "bandit0"

export def "main setup" [] {
    let password = "bandit0"
    let readme_file = "readme"
    
    # Create the readme file with password (format matches original bandit1)
    echo $password | save -f $readme_file
    
    # Set permissions: owner=bandit1, group=bandit0, mode=640
    # In the game setup, this will be called with sudo
    # Owner should be bandit1 (current user is bandit0), group should be bandit0
    echo $"Created $readme_file with password: $password"
    
    { success: true, message: $"Level 0 setup complete" }
}
