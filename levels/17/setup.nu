# Level 17 setup
# Create passwords.old and passwords.new with one line changed

export def "main setup" [] {
    let password = "2W5ogitnLaYap12Y7ZEjlK1aMk12iMlw"
    let next_password = "xjLTmQgKUDm9O95qWS2LJzwoVR01dITt"

    # Generate 100 random passwords
    let passwords = (1..100 | each { |i| random chars --length 32 })
    let old_content = ($passwords | str join "\n")
    let random_line_num = (random int 1..100)
    
    # Replace the random line with next_password
    let lines = ($old_content | lines)
    let random_idx = $random_line_num - 1
    let new_lines = if $random_idx < ($lines | length) {
        let first_part = ($lines | first $random_idx)
        let second_part = if ($random_idx + 1) < ($lines | length) {
            let middle_part = ($lines | skip ($random_idx + 1))
            $first_part | append $next_password | append $middle_part
        } else {
            $first_part | append $next_password
        }
        $second_part
    } else {
        $lines
    }
    let new_content = ($new_lines | str join "\n")

    # Create directory
    if not (bandit_pass | path exists) {
        mkdir bandit_pass
    }

    # Write files
    $old_content | save -f passwords.old
    $new_content | save -f passwords.new

    # Set permissions
    chmod 640 passwords.old
    chmod 640 passwords.new

    # Create bandit_pass files
    echo $password | save -f bandit_pass/bandit17
    echo $next_password | save -f bandit_pass/bandit18

    echo $"Created level 17 with password: $password"

    { success: true, message: $"Level 17 setup complete" }
}

def gen_passwd [] {
    random chars --length 32
}
