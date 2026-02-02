#!/usr/bin/env nu
# Level 27 setup
# Create git repository for bandit27-git user

export def "main setup" [] {
    let bandit27_password = "4cRGHaL3sZmxBaVyFqHgOh6dpzDvjq6n"
    let bandit27_git_password = "4cRGHaL3sZmxBaVyFqHgOh6dpzDvjq6n"

    echo $"Created level 27 with password: $bandit27_password"

    # Create user
    run -n "useradd -m 'bandit27-git' -k '/etc/bandit_skel' -s '/usr/bin/git-shell' -p $(openssl passwd -1 -salt 'bandit' '$bandit27_git_password')"

    # Configure git user
    run -n $"sudo -u bandit27-git bash -c 'git config --global user.name \"bandit\" && git config --global user.email \"bandit@world.net\"'"

    # Create repository
    run -n $"sudo -u bandit27-git bash -c 'mkdir -p /home/bandit27-git/repo && cd /home/bandit27-git/repo && git init -q && echo \"The password to the next level is : 4cRGHaL3sZmxBaVyFqHgOh6dpzDvjq6n\" > readme && git add . && git commit -m \"initial commit\" -q'"

    { success: true, message: $"Level 27 setup complete" }
}
