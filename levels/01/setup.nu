# Setup script for level 1
# Create file named "-" (dashed) containing password

export def "main setup" [] {
    let password = "bandit1"
    let filename = "-"
    
    # Create the file with the password
    echo $password | save -f $filename
    
    echo $"Created file $filename with password: $password"
    
    { success: true, message: $"Level 1 setup complete" }
}
