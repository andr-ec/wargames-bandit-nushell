# Level 05 setup
# Create inhere directory with subdirectories and files with various properties
# Target: exactly 1033 bytes, human-readable, not executable
# Reference: install.sh lines 188-230

export def "main setup" [] {
    let password = "bandit6"
    let folder = "inhere"

    # Create the inhere directory
    mkdir $folder

    # Create subdirectories with files that have random properties
    for i in 0..19 {
        let subdir = $"maybehere($i | fill -a right -c '0' -w 2)"
        mkdir ($folder | path join $subdir)

        for j in 0..9 {
            let filepath = ($folder | path join $subdir | path join $"file($j)")

            # Random size (sometimes 1033, mostly random)
            let size = if (random int 0..4) == 0 { 1033 } else { random int 100..65535 }

            # Create file with random or human-readable content
            if (random int 0..4) == 0 {
                # Human-readable (but wrong size unless it's the target)
                let content = (random chars --length $size)
                $content | save -f $filepath
            } else {
                # Binary data
                ^bash -c $"dd if=/dev/urandom bs=($size) count=1 2>/dev/null" | save -f $filepath
            }

            # Random permissions (sometimes 640, sometimes 750)
            let perm = if (random int 0..3) == 0 { "640" } else { "750" }
            ^chmod $perm $filepath
        }
    }

    # Create the target file - exactly 1033 bytes, human-readable, not executable
    let rnd_dir = $"maybehere($"(random int 0..19)" | fill -a right -c '0' -w 2)"
    let rnd_file = $"file($"(random int 0..9)")"
    let target_path = ($folder | path join $rnd_dir | path join $rnd_file)

    # Pad the password to exactly 1033 bytes
    let prefix = "The password is "
    let padding_needed = 1033 - ($prefix | str length) - ($password | str length)
    let spaces = (1..$padding_needed | each { ' ' } | str join)
    let content = $"($prefix)($password)($spaces)"

    $content | save -f $target_path
    ^chmod 640 $target_path

    { success: true, message: $"Level 5 setup complete - password in ($target_path)" }
}
