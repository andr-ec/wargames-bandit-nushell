#!/usr/bin/env nu
# Level 30 setup
# Create git repository with tagged commit

export def "main setup" [] {
    let bandit30_password = "jN2kgmIDVu4r94XL3CxCoVQa2BFTtDFY"
    let bandit31_password = "G6dZ4dZGWtPWRgS3cx5BWBwqhf3Y2AAT"

    echo $"Created level 30 with password: $bandit30_password"

    # Create user
    run -n "useradd -m 'bandit30-git' -k '/etc/bandit_skel' -s '/usr/bin/git-shell' -p $(openssl passwd -1 -salt 'bandit' '$bandit30_password')"

    # Configure git user
    run -n $"sudo -u bandit30-git bash -c 'git config --global user.name \"bandit\" && git config --global user.email \"bandit@world.net\"'"

    # Create initial commit
    run -n $"sudo -u bandit30-git bash -c 'mkdir -p /home/bandit30-git/repo && cd /home/bandit30-git/repo && git init -q && echo \"Just an empty file ahahah\" > readme && git add . && git commit -m \"initial commit\" -q'"

    # Create tag using hash-object
    run -n $"echo ${bandit31_password}@Q | sudo -u bandit30-git bash -c 'git hash-object -w --stdin > hash'"

    run -n $"sudo -u bandit30-git bash -c 'cd /home/bandit30-git/repo && git tag -a -m ${bandit31_password}@Q secret < hash'"

    run -n $"sudo -u bandit30-git bash -c 'cd /home/bandit30-git/repo && cat hash | tr -d \"\\n\" > .git/packed-refs'"

    run -n $"sudo -u bandit30-git bash -c 'cd /home/bandit30-git/repo && echo \" refs/tags/secret\" >> .git/packed-refs'"

    run -n $"sudo -u bandit30-git bash -c 'cd /home/bandit30-git/repo && rm .git/refs/tags/secret'"

    run -n $"sudo -u bandit30-git bash -c 'cd /home/bandit30-git/repo && rm hash'"

    { success: true, message: $"Level 30 setup complete" }
}
