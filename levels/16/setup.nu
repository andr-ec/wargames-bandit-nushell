# Level 16 setup
# Setup SSL listener on port 30001
# NOTE: This level requires Docker environment with SSL certificates

export def "main setup" [] {
    # In Docker, the listener is started by starter.sh
    # For local testing, we create a mock password file
    let password = "bandit17"

    mkdir bandit_pass
    $password | save -f bandit_pass/bandit17

    # Generate SSL certificate for testing (if openssl available)
    try {
        ^openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout script15.key -out script15.pem -subj "/" 2>/dev/null
    } catch { }

    { success: true, message: "Level 16 setup complete (requires Docker for full functionality)" }
}
