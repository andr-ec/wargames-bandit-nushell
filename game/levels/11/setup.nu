# Level 11 setup
# Create ROT13 encoded data with password
# Reference: install.sh line 294

export def "main setup" [] {
    let password = "bandit12"

    # Apply ROT13 encoding using tr command
    let content = $"The password is ($password)"
    let encoded = ($content | ^tr 'a-mn-zA-MN-Z' 'n-za-mN-ZA-M')

    $encoded | save -f data.txt
    ^chmod 640 data.txt

    { success: true, message: "Level 11 setup complete" }
}
