# Level 05 setup
# Create inhere directory with subdirectories and files with various properties

export def "main setup" [] {
    let password = "bandit6"
    let folder = "inhere"
    
    # Create the inhere directory
    mkdir $folder
    
    # Create subdirectories with files that don't match the target properties
    for i in 0..19 {
        let subdir = $"maybehere$i"
        mkdir ($folder | path join $subdir)
        
        for j in 0..9 {
            let size = if ((random integer -m 1 5) == 0) { 1033 } else { (random integer -m 0 65535) }
            let random_file = ($folder | path join $subdir | path join $"file$j")
            
            echo $"Test content" | save -f $random_file -n $size
            
            # Set random permissions and group
            let perm = if ((random integer -m 1 4) == 0) { 640 } else { 750 }
            chmod $perm $random_file
            chgrp bandit5 $random_file
        }
    }
    
    # Create the target file (1033 bytes, human-readable, not executable)
    # We'll use spaces to create 1033 bytes
    let spaces = " " | str repeat 1033
    let target_dir = "maybehere19"
    let target_file = "file08"
    let target_path = ($folder | path join $target_dir | path join $target_file)
    
    echo $"The password is $password" | save -f $target_path
    
    # Set proper permissions
    chmod 640 $target_path
    chgrp bandit5 $target_path
    
    echo $"Created target file at $target_path with password: $password"
    
    { success: true, message: $"Level 5 setup complete" }
}
