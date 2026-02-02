# Level 26 setup
# This level requires the user to have escaped from the showtext restricted shell
# The setup creates a SUID binary that allows reading the next password
# Reference: install.sh lines 458-462

export def "main setup" [] {
    let password = "bandit27"

    # Create password file for local testing
    mkdir bandit_pass
    $password | save -f bandit_pass/bandit27

    # In Docker, the SUID binary bandit27-do is compiled from scripts/19_suid.c
    # and installed at /home/bandit26/bandit27-do with permissions 4750

    { success: true, message: "Level 26 setup complete" }
}
