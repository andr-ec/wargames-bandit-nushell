#!/usr/bin/env nu
# Level 31 setup
# Create bare git repository with pre-receive hook

export def "main setup" [] {
    let bandit31_password = "jN2kgmIDVu4r94XL3CxCoVQa2BFTtDFY"
    let bandit32_password = "o6E9zT0k2JiQ7lq9oznO6QJv9cTBzXwZ"

    echo $"Created level 31 with password: $bandit31_password"

    # Create user
    run -n "useradd -m 'bandit31-git' -k '/etc/bandit_skel' -s '/usr/bin/git-shell' -p $(openssl passwd -1 -salt 'bandit' '$bandit31_password')"

    # Configure git user
    run -n $"sudo -u bandit31-git bash -c 'git config --global user.name \"bandit\" && git config --global user.email \"bandit@world.net\"'"

    # Create bare repository
    run -n $"sudo -u bandit31-git bash -c 'mkdir -p /home/bandit31-git/repo.git && cd /home/bandit31-git/repo.git && git init --bare -q'"

    # Create pre-receive hook script
    let hook_content = '#!/bin/bash

while read oldref newref refname; do

    newFiles=$(git diff --stat --name-only --diff-filter=ACMRT ${oldref}..${newref})

    for filename in $newFiles; do

        if [[ "$filename" =~ "key.txt" ]]; then

            if [[ "$( git show $newref:$filename )" =~ "Can I come in?" ]]; then
                echo -e "\\n\\nHere'\''s your password : '$bandit32_password'\\n\\n"

            fi

        fi
    done
done

exit 1
'

    run -n $"echo $hook_content | sudo tee /home/bandit31-git/repo.git/hooks/pre-receive"

    # Set correct ownership
    run -n $"chown bandit31-git /home/bandit31-git/repo.git/hooks/pre-receive"

    run -n $"chgrp bandit31-git /home/bandit31-git/repo.git/hooks/pre-receive"

    run -n $"chmod +x /home/bandit31-git/repo.git/hooks/pre-receive"

    { success: true, message: $"Level 31 setup complete" }
}
