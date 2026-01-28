# Setup script for level 2
# Create file with spaces in filename containing password

export def "main setup" [] {
    let password = "bandit2"
    let filename = "spaces in this filename"
    
    # Create the file with the password
    echo $password | save -f $filename
    
    echo $"Created file $filename with password: $password"
    
    { success: true, message: $"Level 2 setup complete" }
}
