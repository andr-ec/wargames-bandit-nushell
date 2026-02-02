# Level 06 setup
# Create file somewhere on server with bandit7:bandit6 ownership
# Reference: install.sh lines 233-238
# NOTE: Requires bandit7/bandit6 users to exist (Docker environment)

export def "main setup" [] {
    let password = "bandit7"

    # Try system path first (Docker), fallback to local for testing
    let folder = if ("/var/lib/dpkg" | path exists) and (^test -w "/var/lib/dpkg" | complete).exit_code == 0 {
        "/var/lib/dpkg/info"
    } else {
        "bandit_pass"
    }
    let filename = "bandit7.password"
    let filepath = ($folder | path join $filename)

    # Create the directory if it doesn't exist
    mkdir $folder

    # Create the file with the password
    $password | save -f $filepath

    # Set ownership to bandit7:bandit6 (requires root and users to exist)
    # This will only work in Docker environment with proper users
    try {
        ^chown bandit7:bandit6 $filepath
        ^chmod 640 $filepath
    } catch {
        # In local testing, ownership change may fail
        try { ^chmod 644 $filepath } catch { }
    }

    { success: true, message: $"Level 6 setup complete - password at ($filepath)" }
}
