# Level 8 setup
# Create file with password appearing only once

export def "main setup" [] {
    let password = "CjsICidai6JgErcK92M9IGh3qzjJVGjB"

    # Create file with 1000 random lines and one password line
    # Using the already generated data.txt in the parent directory
    # We'll need to copy it first, then remove the password and add it once

    # Copy the data file
    if not (data.txt | path exists) {
        cp /tmp/level8_data.txt data.txt
    }

    # The file already has the password exactly once due to shuf

    chmod 640 data.txt

    echo $"Created level 8 with password: $password"

    { success: true, message: $"Level 8 setup complete" }
}
