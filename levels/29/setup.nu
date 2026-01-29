#!/usr/bin/env nu
# Level 29 setup
# Create git repository with multiple branches

export def "main setup" [] {
    let bandit29_password = "ba4e105caeed5e19e973425fe1b0015b"
    let bandit29_git_password = "ba4e105caeed5e19e973425fe1b0015b"
    let bandit30_password = "jN2kgmIDVu4r94XL3CxCoVQa2BFTtDFY"

    echo $"Created level 29 with password: $bandit29_password"

    # Create user
    run -n "useradd -m 'bandit29-git' -k '/etc/bandit_skel' -s '/usr/bin/git-shell' -p $(openssl passwd -1 -salt 'bandit' '$bandit29_git_password')"

    # Configure git user
    run -n $"sudo -u bandit29-git bash -c 'git config --global user.name \"bandit\" && git config --global user.email \"bandit@world.net\"'"

    # Create repository with multiple branches
    run -n $"sudo -u bandit29-git bash -c 'mkdir -p /home/bandit29-git/repo && cd /home/bandit29-git/repo && git init -q && echo \"# Bandit Notes\nSome notes for level29 of bandit.\n\n## credentials\n\n- username: bandit29\n- password: <no passwords in production !>\n\" > readme && git add . && git commit -m \"initial commit\" -q && echo \"# Bandit Notes\nSome notes for level30 of bandit.\n\n## credentials\n\n- username: bandit30\n- password: <no passwords in production !>\n\" > readme && git add . && git commit -m \"fix username\" -q && git checkout -b sploits-dev -q && mkdir exploits && touch exploits/pwn_everything.sh && git add . && git commit -m \"just adding the ultime exploit\" -q && git checkout -b dev -q && mkdir code && touch code/simple_script.sh && git add . && git commit -m \"Simple script\" -q && echo \"# Bandit Notes\nSome notes for level30 of bandit.\n\n## credentials\n\n- username: bandit30\n- password: $bandit30_password\n\" > readme && git add . && git commit -m \"add data needed\" -q && git checkout master -q'"

    { success: true, message: $"Level 29 setup complete" }
}
