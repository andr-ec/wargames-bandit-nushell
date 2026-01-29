# Level 11 setup
# Create ROT13 encoded data with password

export def "main setup" [] {
    let password = "1Qq2WYhvASnzSrU4KSfxYbhpqgC79pwP"

    # Apply ROT13 to password
    let rot13 = $password | encode -r 13

    echo $"The password is $password" | save -f data.txt

    chmod 640 data.txt

    echo $"Created level 11 with password: $password"

    { success: true, message: $"Level 11 setup complete" }
}
