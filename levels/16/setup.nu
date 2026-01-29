# Level 16 setup
# Setup SSL listener on port 30001 and multiple listeners on 31000-32000

export def "main setup" [] {
    let password = "xjLTmQgKUDm9O95qWS2LJzwoVR01dITt"

    # Generate SSL certificate using openssl
    bash -c "openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout script15.key -out script15.pem -subj '/' 1>/dev/null 2>/dev/null"

    echo $"Created level 16 with password: $password"

    { success: true, message: $"Level 16 setup complete" }
}
