# Level 15 setup
# Setup TCP listener on port 30000
# NOTE: This level requires Docker environment with bandit_pass files

export def "main setup" [] {
    # In Docker, the listener is started by starter.sh
    # For local testing, we create a mock password file
    let password = "bandit16"

    mkdir bandit_pass
    $password | save -f bandit_pass/bandit16

    { success: true, message: "Level 15 setup complete (requires Docker for full functionality)" }
}
