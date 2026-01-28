# Setup script for level 3
# Create hidden file in inhere/ directory

export def "main setup" [] {
    let password = "bandit3"
    let filename = "...Hiding-From-You"
    let folder = "inhere"
    
    # Create the inhere directory
    mkdir $folder
    
    # Create the hidden file
    echo $password | save -f ($folder | path join $filename)
    
    echo $"Created hidden file $filename in $folder with password: $password"
    
    { success: true, message: $"Level 3 setup complete" }
}
