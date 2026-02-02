# Level 18 setup
# Create readme file with password and modify .bashrc to log out

export def "main setup" [] {
    let password = "xjLTmQgKUDm9O95qWS2LJzwoVR01dITt"
    let next_password = "Ik8waovuZeOykkk4iAv0lkq5HllJGj7z"

    # Create readme with password
    echo $password | save -f readme

    # Create bandit_pass files
    if not (bandit_pass | path exists) {
        mkdir bandit_pass
    }
    echo $password | save -f bandit_pass/bandit18
    echo $next_password | save -f bandit_pass/bandit19

    # Modify .bashrc to log out
    echo 'echo "Byebye!"' >> .bashrc
    echo 'exit 0' >> .bashrc

    echo $"Created level 18 with password: $password"

    { success: true, message: $"Level 18 setup complete" }
}
