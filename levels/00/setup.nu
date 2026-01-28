# Level 0 Setup
# This level doesn't need any setup as it's the starting point
export def run-setup [] {
    echo "Level 0 is the starting point"
    echo "Password for bandit0 is: bandit0"
}

export def run-check [input: string] {
    let expected = "bandit0"
    validate-password $input $expected
}
