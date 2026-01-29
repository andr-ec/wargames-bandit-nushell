#!/usr/bin/env nu
# Level 28 setup
# Create git repository with multiple commits

export def "main setup" [] {
    let bandit28_password = "56a9d190189b0a7debe49dab5fee5c2e"
    let bandit28_git_password = "56a9d190189b0a7debe49dab5fee5c2e"

    echo $"Created level 28 with password: $bandit28_password"

    # Create user
    run -n "useradd -m 'bandit28-git' -k '/etc/bandit_skel' -s '/usr/bin/git-shell' -p $(openssl passwd -1 -salt 'bandit' '$bandit28_git_password')"

    # Configure git user
    run -n $"sudo -u bandit28-git bash -c 'git config --global user.name \"bandit\" && git config --global user.email \"bandit@world.net\"'"

    # Create repository with multiple commits
    run -n $"sudo -u bandit28-git bash -c 'mkdir -p /home/bandit28-git/repo && cd /home/bandit28-git/repo && git init -q && echo \"# Bandit Notes\nSome notes for level29 of bandit.\n\n## credentials\n\n- username: bandit29\n- password: <TBD>\n\" > readme && git add . && git commit -m \"initial commit\" -q && echo \"# Bandit Notes\nSome notes for level29 of bandit.\n\n## credentials\n\n- username: bandit29\n- password: $bandit28_password\n\" > readme && git add . && git commit -m \"add missing data\" -q && echo \"# Bandit Notes\nSome notes for level29 of bandit.\n\n## credentials\n\n- username: bandit29\n- password: xxxxxxxxxxxx\n\" > readme && git add . && git commit -m \"fix info leak\" -q'"

    { success: true, message: $"Level 28 setup complete" }
}
