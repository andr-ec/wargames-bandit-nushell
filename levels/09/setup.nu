# Level 09 setup
# Create binary file with password embedded as human-readable string
# Reference: install.sh - password preceded by several '=' characters

export def "main setup" [] {
    let password = "bandit10"

    # Create binary file with the password embedded as human-readable string
    # The password is preceded by several '=' characters
    let marker = "======== "
    let embedded_string = $"($marker)($password)"

    # Create binary data using dd, then append the embedded string
    ^bash -c $"dd if=/dev/urandom bs=1024 count=10 2>/dev/null > data.txt"
    $"\n($embedded_string)\n" | ^bash -c "cat >> data.txt"
    ^bash -c "dd if=/dev/urandom bs=1024 count=5 2>/dev/null >> data.txt"

    ^chmod 640 data.txt

    { success: true, message: "Level 9 setup complete" }
}
