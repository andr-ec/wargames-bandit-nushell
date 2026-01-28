# Level 9 setup
# Create binary file with password embedded as human-readable string

export def "main setup" [] {
    let password = "813VXyMr4N5uP1W30wddJy1OknNg30AQ"

    # Create binary file with random data
    # The password will be embedded as a human-readable string preceded by many '=' chars
    let before = (random chars -l 20)
    let after = (random chars -l 20)
    let embedded_string = $"{before}======== {password}     {after}"

    # Create random binary data
    let random_data = (random bytes -l 200000)

    # Combine random data with the embedded string
    let combined_data = $"$random_data{embedded_string}"

    # Save to data.txt
    $combined_data | save -f data.txt

    chmod 640 data.txt

    echo $"Created level 9 with password: $password"

    { success: true, message: $"Level 9 setup complete" }
}
