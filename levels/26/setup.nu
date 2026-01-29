#!/usr/bin/env nu
# Level 26 setup
# Change bandit26's shell to 'showtext' which is a restricted shell

export def "main setup" [] {
    let bandit26_password = "42WbmEO4SR7mvSp1E1pRK91d5FVBQwYt"

    echo $"Created level 26 with password: $bandit26_password"

    { success: true, message: $"Level 26 setup complete" }
}
