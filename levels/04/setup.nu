# Level 04 setup
# Create inhere directory with human-readable file

export def "main setup" [] {
    let password = "bandit5"
    let folder = "inhere"
    let filename = "txt7"
    
    # Create the inhere directory
    mkdir $folder
    
    # Create the human-readable file with the password
    echo $password | save -f ($folder | path join $filename)
    
    echo $"Created human-readable file $filename in $folder with password: $password"
    
    { success: true, message: $"Level 4 setup complete" }
}
