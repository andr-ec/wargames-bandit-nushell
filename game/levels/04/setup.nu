# Level 04 setup
# Create inhere directory with many binary files and one human-readable file
# Reference: install.sh lines 163-185

export def "main setup" [] {
    let password = "bandit5"
    let folder = "inhere"

    # Create the inhere directory
    mkdir $folder

    # Pick a random file index for the password (0-9)
    let target_idx = (random int 0..9)

    # Create 10 files named -file00 to -file09
    for i in 0..9 {
        let filename = $"-file0($i)"
        let filepath = ($folder | path join $filename)

        if $i == $target_idx {
            # This file contains the password (human-readable)
            $password | save -f $filepath
        } else {
            # Create binary (non-human-readable) data using bash+dd
            ^bash -c $"dd if=/dev/urandom bs=32 count=1 2>/dev/null" | save -f $filepath
        }
    }

    { success: true, message: $"Level 4 setup complete - password in -file0($target_idx)" }
}
