# Level 10 setup
# Create base64 encoded data with password embedded

export def "main setup" [] {
    let password = "67sYOyDZiFTve0q0sCu5Tuq82A3BssJ2"

    # Encode password as base64 and save to data.txt
    echo $"The password is $password" | base64 | save -f data.txt

    chmod 640 data.txt

    echo $"Created level 10 with password: $password"

    { success: true, message: $"Level 10 setup complete" }
}
