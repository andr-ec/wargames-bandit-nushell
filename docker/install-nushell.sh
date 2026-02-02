#!/bin/bash
# Install script for Nushell Bandit Wargame
# Creates users with Nushell as their shell and sets up level challenges

set -e

# Generates 32-char random password
gen_passwd() {
    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1
}

# Creates a bandit user with Nushell shell
create_user() {
    local username="$1"
    local pass

    if [ "$username" = "bandit0" ]; then
        pass='bandit0'
    else
        pass=$(gen_passwd)
    fi

    # Create user with Nushell as shell
    useradd -m "$username" -k "/etc/bandit_skel" -s "/usr/local/bin/nu" -p $(openssl passwd -1 -salt "bandit" "$pass")

    # Create .ssh directory
    mkdir -p "/home/$username/.ssh"
    chown "$username:$username" "/home/$username/.ssh"
    chmod 700 "/home/$username/.ssh"

    # Store password in /etc/bandit_pass
    echo "$pass" > "/etc/bandit_pass/$username"
    chown "$username:$username" "/etc/bandit_pass/$username"
    chmod 400 "/etc/bandit_pass/$username"

    echo "$pass"
}

# Sets permissions on a file: banditX as group, banditX+1 as owner
set_perms() {
    local level=$1
    local filepath="$2"
    local mode="$3"
    chown "bandit$((level+1))" "$filepath"
    chgrp "bandit$level" "$filepath"
    chmod "$mode" "$filepath"
}

# Extracts commands from goal.txt Nushell section
extract_commands() {
    local goal_file="$1"
    if [ -f "$goal_file" ]; then
        # Extract command names from markdown links like [ls](url)
        grep -oP '\[\K[^\]]+(?=\]\(https://www\.nushell\.sh)' "$goal_file" 2>/dev/null | tr '\n' ', ' | sed 's/,$//' || echo "ls, cd, open"
    else
        echo "ls, cd, open"
    fi
}

# Create MOTD goal and Nushell config for user
create_user_config() {
    local level=$1
    local username="bandit$level"
    local goal_file="/game/levels/$(printf '%02d' $level)/goal.txt"

    # Copy goal.txt to /etc/bandit_goal if it exists
    if [ -f "$goal_file" ]; then
        # Extract just the goal section (between Level Goal header and next section)
        # Skip the front matter (---), "Level Goal" header, and separator lines
        awk '
            /^Level Goal$/,/^(Nushell commands|Helpful Reading Material)/ {
                if (/^Level Goal$/ || /^-+$/ || /^Nushell commands/ || /^Helpful Reading/) next
                print
            }
        ' "$goal_file" | sed '/^[[:space:]]*$/d' > "/etc/bandit_goal/$username"
    else
        echo "Complete this level to find the password for the next level." > "/etc/bandit_goal/$username"
    fi
    chmod 444 "/etc/bandit_goal/$username"

    # Extract commands for this level
    local commands=$(extract_commands "$goal_file")

    # Create Nushell config directory
    local config_dir="/home/$username/.config/nushell"
    mkdir -p "$config_dir"

    # Create env.nu with level info
    cat > "$config_dir/env.nu" << EOF
# Bandit Wargame Environment
\$env.BANDIT_LEVEL = $level
\$env.BANDIT_USER = "$username"
\$env.BANDIT_COMMANDS = "$commands"
\$env.PROMPT_COMMAND = { || "$username:~> " }
\$env.PROMPT_INDICATOR = ""
EOF

    # Create config.nu (minimal)
    cat > "$config_dir/config.nu" << 'EOF'
# Bandit Wargame Nushell Config

$env.config = {
    show_banner: false
    shell_integration: {
        osc2: false
        osc7: false
        osc8: false
        osc9_9: false
        osc133: false
        osc633: false
        reset_application_mode: false
    }
}

# Goal command - show level objective
def goal [] {
    open $"/etc/bandit_goal/bandit($env.BANDIT_LEVEL)"
}

# Login banner
source ~/.config/nushell/login.nu
EOF

    # Create login.nu with welcome message
    cat > "$config_dir/login.nu" << 'LOGINEOF'
# Welcome Banner
print ""
print "══════════════════════════════════════════════════════════════════"
print "  Bandit Wargame - Nushell Edition"
print "══════════════════════════════════════════════════════════════════"
print ""

print $"(ansi cyan_bold)Level ($env.BANDIT_LEVEL)(ansi reset)"
print ""

print $"(ansi yellow)Goal:(ansi reset)"
open $"/etc/bandit_goal/bandit($env.BANDIT_LEVEL)" | print
print ""

print $"(ansi yellow)Useful commands for this level:(ansi reset)"
print $"  ($env.BANDIT_COMMANDS)"
print ""

print $"(ansi yellow)Getting help:(ansi reset)"
print "  help <command>     - Show help for a command"
print "  <command> --help   - Alternative help syntax"
print "  goal               - Show this level's goal again"
print ""
LOGINEOF

    # Set ownership
    chown -R "$username:$username" "$config_dir"
}

# Run the Nushell setup script for a level
run_level_setup() {
    local level=$1
    local username="bandit$level"
    local level_dir="/game/levels/$(printf '%02d' $level)"
    local setup_script="$level_dir/setup.nu"

    if [ -f "$setup_script" ]; then
        echo -n "Running setup for level $level... "

        # Run setup.nu as the user in their home directory
        cd "/home/$username"

        # Source the setup script and run 'main setup'
        /usr/local/bin/nu -c "use $setup_script; main setup" 2>/dev/null || \
        /usr/local/bin/nu -c "cd /home/$username; source $setup_script; main setup" 2>/dev/null || \
            echo "(no setup needed)"

        echo "done"
    fi
}

# Main installation
echo "Installing Nushell Bandit Wargame..."

# Create MOTD (try game/data/motd.txt first, fallback to embedded)
touch /etc/motd
if [ -f "/game/data/motd.txt" ]; then
    cp /game/data/motd.txt /etc/motd
else
    cat > /etc/motd << 'MOTDEOF'

   ____                   _ _ _     ____                  _ _ _
  |  _ \                 | (_) |   |  _ \                | (_) |
  | |_) | __ _ _ __   __| |_| |_  | |_) | __ _ _ __   __| |_| |_
  |  _ < / _` | '_ \ / _` | | __| |  _ < / _` | '_ \ / _` | | __|
  | |_) | (_| | | | | (_| | | |_  | |_) | (_| | | | | (_| | | |_
  |____/ \__,_|_| |_|\__,_|_|\__| |____/ \__,_|_| |_|\__,_|_|\__|

                    Nushell Edition

  Learn Nushell by playing! Use 'goal' to see your current objective.

MOTDEOF
fi

# Store passwords for reference during setup
declare -a passwords

echo "Creating users..."
for i in $(seq 0 39); do
    pass=$(create_user "bandit$i")
    passwords+=("$pass")
    echo "  Created bandit$i"
done
echo "Users created."

echo "Setting up user configs..."
for i in $(seq 0 39); do
    create_user_config $i
done
echo "User configs created."

# Manual setup for levels that need specific file creation
# These mirror the original install.sh logic but adapted for the Nushell game

echo "Setting up levels..."

# Level 0: readme file with password for level 1
echo -n "Level 0... "
echo -e "The password you are looking for is: ${passwords[1]}" > '/home/bandit0/readme'
set_perms 0 '/home/bandit0/readme' 640
echo "done"

# Level 1: file named '-'
echo -n "Level 1... "
echo "${passwords[2]}" > '/home/bandit1/-'
set_perms 1 '/home/bandit1/-' 640
echo "done"

# Level 2: file with spaces in name
echo -n "Level 2... "
echo "${passwords[3]}" > "/home/bandit2/spaces in this filename"
set_perms 2 "/home/bandit2/spaces in this filename" 640
echo "done"

# Level 3: hidden file in directory
echo -n "Level 3... "
mkdir -p /home/bandit3/inhere
echo "${passwords[4]}" > '/home/bandit3/inhere/...Hiding-From-You'
set_perms 3 '/home/bandit3/inhere/...Hiding-From-You' 640
echo "done"

# Level 4: human-readable file among binary files
echo -n "Level 4... "
mkdir -p /home/bandit4/inhere
x=$((RANDOM % 50))
for i in $(seq 0 50); do
    fi=$(printf "%02d" $i)
    fx=$(printf "%02d" $x)
    check_type=0
    while [ $check_type -eq 0 ]; do
        cat /dev/urandom | head -c 32 > "/home/bandit4/inhere/-file$fi"
        type=$(file "/home/bandit4/inhere/-file$fi" | cut -d ' ' -f 2)
        if [ "$type" = "data" ]; then check_type=1; fi
    done
    set_perms 4 "/home/bandit4/inhere/-file$fi" 640
done
echo "${passwords[5]}" > "/home/bandit4/inhere/-file$fx"
echo "done"

# Level 5: file with specific size (1033 bytes) in nested directories
echo -n "Level 5... "
mkdir -p /home/bandit5/inhere
for i in $(seq -w 0 19); do
    mkdir -p "/home/bandit5/inhere/maybehere$i"
    for j in $(seq 0 9); do
        if [[ $((RANDOM % 5)) -eq 0 ]]; then
            size=1033
        else
            size=$((RANDOM % 32000 + 100))
        fi
        if [[ $((RANDOM % 5)) -eq 0 ]]; then
            cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w "$size" | head -n 1 > "/home/bandit5/inhere/maybehere$i/file$j"
        else
            cat /dev/urandom | head -c "$size" > "/home/bandit5/inhere/maybehere$i/file$j"
        fi
        if [[ $((RANDOM % 4)) -eq 0 ]]; then
            chmod 640 "/home/bandit5/inhere/maybehere$i/file$j"
        else
            chmod 750 "/home/bandit5/inhere/maybehere$i/file$j"
        fi
        chgrp bandit5 "/home/bandit5/inhere/maybehere$i/file$j"
    done
done
rnd_dir=$(seq -w 0 19 | shuf | head -n 1)
rnd_file=$(seq -w 0 9 | shuf | head -n 1)
spaces=$(python3 -c "print(' ' * 984)")
echo "The password is ${passwords[6]}$spaces" > "/home/bandit5/inhere/maybehere$rnd_dir/file$rnd_file"
chmod 640 "/home/bandit5/inhere/maybehere$rnd_dir/file$rnd_file"
echo "done"

# Level 6: file somewhere on server with specific owner/group/size
echo -n "Level 6... "
mkdir -p /var/lib/dpkg/info/
echo "${passwords[7]}" > /var/lib/dpkg/info/bandit7.password
set_perms 6 /var/lib/dpkg/info/bandit7.password 640
echo "done"

# Level 7: data.txt with word 'millionth'
echo -n "Level 7... "
wordlist_found=false
for wordlist_path in "/game/data/7_wordlist.txt.gz" "/game/7_wordlist.txt.gz"; do
    if [ -f "$wordlist_path" ]; then
        cp "$wordlist_path" /home/bandit7/7_wordlist.txt.gz
        gzip -d /home/bandit7/7_wordlist.txt.gz
        word="millionth"
        line=$(grep "$word" /home/bandit7/7_wordlist.txt || echo "millionth	placeholder")
        sed -i "s/$line/$word\t${passwords[8]}/" /home/bandit7/7_wordlist.txt
        mv /home/bandit7/7_wordlist.txt /home/bandit7/data.txt
        wordlist_found=true
        break
    fi
done
if [ "$wordlist_found" = false ]; then
    # Create simple data file if wordlist not found
    for i in $(seq 1 100000); do
        echo "word$i	$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 32)"
    done > /home/bandit7/data.txt
    echo "millionth	${passwords[8]}" >> /home/bandit7/data.txt
    sort -R /home/bandit7/data.txt -o /home/bandit7/data.txt
fi
set_perms 7 /home/bandit7/data.txt 640
echo "done"

# Level 8: data.txt with unique line
echo -n "Level 8... "
touch /home/bandit8/data_tmp.txt
for i in $(seq 1 100); do
    rnd_string=$(gen_passwd)
    for j in $(seq 1 10); do
        echo "$rnd_string" >> /home/bandit8/data_tmp.txt
    done
done
echo "${passwords[9]}" >> /home/bandit8/data_tmp.txt
shuf /home/bandit8/data_tmp.txt > /home/bandit8/data.txt
rm /home/bandit8/data_tmp.txt
set_perms 8 /home/bandit8/data.txt 640
echo "done"

# Level 9: binary file with strings
echo -n "Level 9... "
cat /dev/urandom | fold -w $((RANDOM % 9000 + 1000)) | head -n 1 > /home/bandit9/data.txt
echo -n "======== ${passwords[10]}     " >> /home/bandit9/data.txt
cat /dev/urandom | fold -w $((RANDOM % 9000 + 1000)) | head -n 1 >> /home/bandit9/data.txt
set_perms 9 /home/bandit9/data.txt 640
echo "done"

# Level 10: base64 encoded
echo -n "Level 10... "
echo "The password is ${passwords[11]}" | base64 > /home/bandit10/data.txt
set_perms 10 /home/bandit10/data.txt 640
echo "done"

# Level 11: ROT13
echo -n "Level 11... "
echo "The password is ${passwords[12]}" | tr 'a-mn-z' 'n-za-m' | tr 'A-MN-Z' 'N-ZA-M' > /home/bandit11/data.txt
set_perms 11 /home/bandit11/data.txt 640
echo "done"

# Level 12: compressed hexdump
echo -n "Level 12... "
tmpdir=$(mktemp -d)
cd "$tmpdir"
echo "${passwords[13]}" > "data8"
gzip -c "data8" > "data8.bin"
tar cvf "data7.tar" --absolute-names "data8.bin" >/dev/null 2>&1
bzip2 -c "data7.tar" > "data6.bin"
tar cvf "data5.bin" --absolute-names "data6.bin" >/dev/null 2>&1
tar cvf "data4.bin" --absolute-names "data5.bin" >/dev/null 2>&1
gzip -c "data4.bin" > "data3.bin"
bzip2 -c "data3.bin" > "data2.bin"
gzip -c "data2.bin" > "data1.bin"
xxd "data1.bin" > /home/bandit12/data.txt
rm -rf "$tmpdir"
set_perms 12 /home/bandit12/data.txt 640
echo "done"

# Level 13: SSH key for level 14
echo -n "Level 13... "
ssh-keygen -q -f /tmp/sshkey.private -N "" >/dev/null 2>&1
mv /tmp/sshkey.private /home/bandit13/
set_perms 13 /home/bandit13/sshkey.private 640
mkdir -p /home/bandit14/.ssh
mv /tmp/sshkey.private.pub /home/bandit14/.ssh/authorized_keys
chown bandit14:bandit14 /home/bandit14/.ssh/authorized_keys
chmod 600 /home/bandit14/.ssh/authorized_keys
echo "done"

# Level 14: TCP listener
echo -n "Level 14... "
cp /etc/bandit_scripts/14_listener_tcp.py /etc/bandit_scripts/script14.py 2>/dev/null || true
echo "@reboot root python3 /etc/bandit_scripts/script14.py &> /dev/null" > /etc/cron.d/cronjob_bandit14
echo "done"

# Level 15: SSL listener
echo -n "Level 15... "
cp /etc/bandit_scripts/15_listener_ssl.py /etc/bandit_scripts/script15.py 2>/dev/null || true
echo "@reboot root python3 /etc/bandit_scripts/script15.py &> /dev/null" > /etc/cron.d/cronjob_bandit15
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/bandit_scripts/script15.key \
    -out /etc/bandit_scripts/script15.pem \
    -subj "/" >/dev/null 2>&1
echo "done"

# Level 16: multiple SSL listeners
echo -n "Level 16... "
ssh-keygen -q -f /tmp/sshkey17.private -N "" >/dev/null 2>&1
mv /tmp/sshkey17.private /etc/bandit_scripts/sshkey17.private
mkdir -p /home/bandit17/.ssh
mv /tmp/sshkey17.private.pub /home/bandit17/.ssh/authorized_keys
chown bandit17:bandit17 /home/bandit17/.ssh/authorized_keys
chmod 600 /home/bandit17/.ssh/authorized_keys
cp /etc/bandit_scripts/16_multiple_listeners.py /etc/bandit_scripts/script16.py 2>/dev/null || true
echo "@reboot root python3 /etc/bandit_scripts/script16.py &> /dev/null" > /etc/cron.d/cronjob_bandit16
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/bandit_scripts/script16.key \
    -out /etc/bandit_scripts/script16.pem \
    -subj "/" >/dev/null 2>&1
echo "done"

# Level 17: diff two files
echo -n "Level 17... "
touch /home/bandit17/passwords.old
set_perms 17 /home/bandit17/passwords.old 640
for i in $(seq 1 100); do
    gen_passwd >> /home/bandit17/passwords.old
done
rnd_line=$(sed -n -e $((RANDOM % 100 + 1))p /home/bandit17/passwords.old)
sed "s/$rnd_line/${passwords[18]}/" /home/bandit17/passwords.old > /home/bandit17/passwords.new
set_perms 17 /home/bandit17/passwords.new 640
echo "done"

# Level 18: bashrc exit trick
echo -n "Level 18... "
echo "${passwords[19]}" > /home/bandit18/readme
set_perms 18 /home/bandit18/readme 640
# Add exit to profile (this affects bash if they try that shell)
echo 'echo "Byebye!"' >> /home/bandit18/.bashrc
echo 'exit 0' >> /home/bandit18/.bashrc
echo "done"

# Level 19: SUID binary
echo -n "Level 19... "
if [ -f "/etc/bandit_scripts/19_suid.c" ]; then
    gcc /etc/bandit_scripts/19_suid.c -o /home/bandit19/bandit20-do
    set_perms 19 /home/bandit19/bandit20-do 4750
fi
echo "done"

# Level 20: TCP connect SUID
echo -n "Level 20... "
if [ -f "/etc/bandit_scripts/20_tcp_connect.c" ]; then
    gcc /etc/bandit_scripts/20_tcp_connect.c -o /home/bandit20/suconnect
    set_perms 20 /home/bandit20/suconnect 4750
fi
echo "done"

# Levels 21-24: cron jobs
echo -n "Levels 21-24 (cron)... "
if [ -f "/etc/bandit_scripts/22_tmp_file.sh" ]; then
    echo "@reboot bandit22 /usr/bin/cronjob_bandit22.sh &> /dev/null" > /etc/cron.d/cronjob_bandit22
    echo "* * * * * bandit22 /usr/bin/cronjob_bandit22.sh &> /dev/null" >> /etc/cron.d/cronjob_bandit22
    sed "s/__PLACEHOLDER__/$(gen_passwd)/" /etc/bandit_scripts/22_tmp_file.sh > /usr/bin/cronjob_bandit22.sh
    chown bandit22:bandit21 /usr/bin/cronjob_bandit22.sh
    chmod 750 /usr/bin/cronjob_bandit22.sh
fi
if [ -f "/etc/bandit_scripts/23_tmp_file2.sh" ]; then
    echo "@reboot bandit23 /usr/bin/cronjob_bandit23.sh &> /dev/null" > /etc/cron.d/cronjob_bandit23
    echo "* * * * * bandit23 /usr/bin/cronjob_bandit23.sh &> /dev/null" >> /etc/cron.d/cronjob_bandit23
    cp /etc/bandit_scripts/23_tmp_file2.sh /usr/bin/cronjob_bandit23.sh
    chown bandit23:bandit22 /usr/bin/cronjob_bandit23.sh
    chmod 750 /usr/bin/cronjob_bandit23.sh
fi
if [ -f "/etc/bandit_scripts/24_script_launcher.sh" ]; then
    echo "@reboot bandit24 /usr/bin/cronjob_bandit24.sh &> /dev/null" > /etc/cron.d/cronjob_bandit24
    echo "* * * * * bandit24 /usr/bin/cronjob_bandit24.sh &> /dev/null" >> /etc/cron.d/cronjob_bandit24
    mkdir -p /var/spool/bandit24/foo
    chmod 777 /var/spool/bandit24/foo
    cp /etc/bandit_scripts/24_script_launcher.sh /usr/bin/cronjob_bandit24.sh
    chown bandit24:bandit23 /usr/bin/cronjob_bandit24.sh
    chmod 750 /usr/bin/cronjob_bandit24.sh
fi
echo "done"

# Level 24: pin brute force
echo -n "Level 24 (pin)... "
pin=$(printf "%04d" $((RANDOM % 10000)))
echo "$pin" > /etc/bandit_pass/bandit25pin
chown bandit25:bandit25 /etc/bandit_pass/bandit25pin
chmod 400 /etc/bandit_pass/bandit25pin
if [ -f "/etc/bandit_scripts/25_listener_pin.py" ]; then
    cp /etc/bandit_scripts/25_listener_pin.py /etc/bandit_scripts/script25.py
    echo "@reboot root python3 /etc/bandit_scripts/script25.py &> /dev/null" > /etc/cron.d/cronjob_bandit25
fi
echo "done"

# Level 25: SSH to level 26 with restricted shell
echo -n "Level 25... "
ssh-keygen -q -f /tmp/bandit26.sshkey -N "" >/dev/null 2>&1
mv /tmp/bandit26.sshkey /home/bandit25/
set_perms 25 /home/bandit25/bandit26.sshkey 640
mkdir -p /home/bandit26/.ssh
mv /tmp/bandit26.sshkey.pub /home/bandit26/.ssh/authorized_keys
chown bandit26:bandit26 /home/bandit26/.ssh/authorized_keys
chmod 600 /home/bandit26/.ssh/authorized_keys
# Create showtext script
cat > /usr/bin/showtext << 'SHOWTEXT'
#!/bin/sh
export ENV=~/.profile
SHELL=/bin/sh
more /etc/motd
SHOWTEXT
chmod +x /usr/bin/showtext
echo "/usr/bin/showtext" >> /etc/shells
usermod -s /usr/bin/showtext bandit26
echo "done"

# Level 26: SUID binary
echo -n "Level 26... "
if [ -f "/etc/bandit_scripts/19_suid.c" ]; then
    gcc /etc/bandit_scripts/19_suid.c -o /home/bandit26/bandit27-do
    set_perms 26 /home/bandit26/bandit27-do 4750
fi
echo "done"

# Levels 27-31: Git levels
echo -n "Levels 27-31 (git)... "

# Level 27
useradd -m "bandit27-git" -k "/etc/bandit_skel" -s "/usr/bin/git-shell" \
    -p $(openssl passwd -1 -salt "bandit" "${passwords[27]}") 2>/dev/null || true
sudo -u bandit27-git bash -c "
    git config --global user.name 'bandit'
    git config --global user.email 'bandit@world.net'
    mkdir -p /home/bandit27-git/repo
    cd /home/bandit27-git/repo
    git init -q
    echo 'The password to the next level is : ${passwords[28]}' > readme
    git add .
    git commit -m 'initial commit' -q
" 2>/dev/null || true

# Level 28
useradd -m "bandit28-git" -k "/etc/bandit_skel" -s "/usr/bin/git-shell" \
    -p $(openssl passwd -1 -salt "bandit" "${passwords[28]}") 2>/dev/null || true
sudo -u bandit28-git bash -c "
    git config --global user.name 'bandit'
    git config --global user.email 'bandit@world.net'
    mkdir -p /home/bandit28-git/repo
    cd /home/bandit28-git/repo
    git init -q
    echo -e '# Bandit Notes\nSome notes for level29 of bandit.\n\n## credentials\n\n- username: bandit29\n- password: <TBD>\n' > readme
    git add .
    git commit -m 'initial commit' -q
    echo -e '# Bandit Notes\nSome notes for level29 of bandit.\n\n## credentials\n\n- username: bandit29\n- password: ${passwords[29]}\n' > readme
    git add .
    git commit -m 'add missing data' -q
    echo -e '# Bandit Notes\nSome notes for level29 of bandit.\n\n## credentials\n\n- username: bandit29\n- password: xxxxxxxxxxxx\n' > readme
    git add .
    git commit -m 'fix info leak' -q
" 2>/dev/null || true

# Level 29
useradd -m "bandit29-git" -k "/etc/bandit_skel" -s "/usr/bin/git-shell" \
    -p $(openssl passwd -1 -salt "bandit" "${passwords[29]}") 2>/dev/null || true
sudo -u bandit29-git bash -c "
    git config --global user.name 'bandit'
    git config --global user.email 'bandit@world.net'
    mkdir -p /home/bandit29-git/repo
    cd /home/bandit29-git/repo
    git init -q
    echo -e '# Bandit Notes\nSome notes for level29 of bandit.\n\n## credentials\n\n- username: bandit29\n- password: <no passwords in production !>\n' > readme
    git add .
    git commit -m 'initial commit' -q
    echo -e '# Bandit Notes\nSome notes for level30 of bandit.\n\n## credentials\n\n- username: bandit30\n- password: <no passwords in production !>\n' > readme
    git add .
    git commit -m 'fix username' -q
    git checkout -b sploits-dev -q
    mkdir exploits
    touch exploits/pwn_everything.sh
    git add .
    git commit -m 'just adding the ultime exploit' -q
    git checkout -b dev -q
    mkdir code
    touch code/simple_script.sh
    git add .
    git commit -m 'Simple script' -q
    echo -e '# Bandit Notes\nSome notes for level30 of bandit.\n\n## credentials\n\n- username: bandit30\n- password: ${passwords[30]}\n' > readme
    git add .
    git commit -m 'add data needed' -q
    git checkout master -q
" 2>/dev/null || true

# Level 30
useradd -m "bandit30-git" -k "/etc/bandit_skel" -s "/usr/bin/git-shell" \
    -p $(openssl passwd -1 -salt "bandit" "${passwords[30]}") 2>/dev/null || true
sudo -u bandit30-git bash -c "
    git config --global user.name 'bandit'
    git config --global user.email 'bandit@world.net'
    mkdir -p /home/bandit30-git/repo
    cd /home/bandit30-git/repo
    git init -q
    echo 'Just an empty file ahahah' > readme
    git add .
    git commit -m 'initial commit' -q
" 2>/dev/null || true

# Add secret tag for level 30
sudo -u bandit30-git bash -c "
    cd /home/bandit30-git/repo
    hash=\$(echo '${passwords[31]}' | git hash-object -w --stdin)
    git tag -a -m '${passwords[31]}' secret \$hash 2>/dev/null || true
" 2>/dev/null || true

# Level 31
useradd -m "bandit31-git" -k "/etc/bandit_skel" -s "/usr/bin/git-shell" \
    -p $(openssl passwd -1 -salt "bandit" "${passwords[31]}") 2>/dev/null || true
sudo -u bandit31-git bash -c "
    git config --global user.name 'bandit'
    git config --global user.email 'bandit@world.net'
    mkdir -p /home/bandit31-git/repo
    cd /home/bandit31-git/repo
    git init -q
    echo \"This time you'll need to commit and push a file name key.txt that contains 'Can I come in?'\" > readme
    git add .
    git commit -m 'initial commit' -q
    mv .git ../repo.git
    cd ..
    rm -fr repo
    cd repo.git
    git config --bool core.bare true
" 2>/dev/null || true

if [ -f "/etc/bandit_scripts/31_git_hook" ]; then
    sed "s/__PLACEHOLDER__/${passwords[32]}/" /etc/bandit_scripts/31_git_hook > /home/bandit31-git/repo.git/hooks/pre-receive
    chown bandit31-git:bandit31-git /home/bandit31-git/repo.git/hooks/pre-receive
    chmod +x /home/bandit31-git/repo.git/hooks/pre-receive
fi
echo "done"

# Level 32: uppershell
echo -n "Level 32... "
echo "${passwords[33]}" > /home/bandit32/readme
chown bandit33:bandit32 /home/bandit32/readme
chmod 640 /home/bandit32/readme
if [ -f "/etc/bandit_scripts/32_uppershell.c" ]; then
    # Need to set the goal in the uppershell
    goal="After all this git stuff, it's time for another escape. Good luck!"
    sed "s/__PLACEHOLDER__/$goal/" /etc/bandit_scripts/32_uppershell.c > /tmp/uppershell.c
    gcc /tmp/uppershell.c -o /home/bandit32/uppershell
    set_perms 32 /home/bandit32/uppershell 4750
    usermod -s /home/bandit32/uppershell bandit32
    rm /tmp/uppershell.c
fi
echo "done"

# Level 33: environment variable
echo -n "Level 33... "
# Store password in profile that self-destructs
cat > /home/bandit33/.profile << PROFILE33
export bandit34=${passwords[34]}
head -n 4 /home/bandit33/.profile > /home/bandit33/profile2
mv /home/bandit33/profile2 /home/bandit33/.profile
PROFILE33
chown bandit33:bandit33 /home/bandit33/.profile
chmod 744 /home/bandit33/.profile
echo "done"

# Level 34: recently modified file
echo -n "Level 34... "
mkdir -p /usr/local/share/man/
rnd_file=$(gen_passwd)
echo "${passwords[35]}" > "/usr/local/share/man/$rnd_file"
if [ -f "/etc/bandit_scripts/35_cron_touch.sh" ]; then
    echo "@reboot bandit35 /usr/bin/cronjob_bandit35.sh &> /dev/null" > /etc/cron.d/cronjob_bandit35
    echo "* * * * * bandit35 /usr/bin/cronjob_bandit35.sh &> /dev/null" >> /etc/cron.d/cronjob_bandit35
    sed "s/__PLACEHOLDER__/$rnd_file/" /etc/bandit_scripts/35_cron_touch.sh > /usr/bin/cronjob_bandit35.sh
    chown bandit35:bandit35 /usr/bin/cronjob_bandit35.sh
    chmod 750 /usr/bin/cronjob_bandit35.sh
fi
echo "done"

# Level 35: SUID base64
echo -n "Level 35... "
cp /usr/bin/base64 /home/bandit35/base64 2>/dev/null || \
    ln -s /usr/bin/base64 /home/bandit35/base64 2>/dev/null || true
set_perms 35 /home/bandit35/base64 4750
echo "done"

# Level 36: SUID find
echo -n "Level 36... "
cp /usr/bin/find /home/bandit36/find 2>/dev/null || \
    ln -s /usr/bin/find /home/bandit36/find 2>/dev/null || true
set_perms 36 /home/bandit36/find 4750
echo "done"

# Level 37: SUID cp
echo -n "Level 37... "
cp /bin/cp /home/bandit37/cp 2>/dev/null || \
    ln -s /bin/cp /home/bandit37/cp 2>/dev/null || true
set_perms 37 /home/bandit37/cp 4750
echo "done"

# Level 38: python shell escape
echo -n "Level 38... "
echo "${passwords[39]}" > /home/bandit38/readme
set_perms 37 /home/bandit38/readme 640
usermod -s /usr/bin/python3 bandit38
echo "done"

# Level 39: Final level
echo -n "Level 39... "
echo "Congratulations! You've completed the Bandit Wargame - Nushell Edition!" > /home/bandit39/readme
chown bandit39:bandit39 /home/bandit39/readme
chmod 644 /home/bandit39/readme
echo "done"

echo ""
echo "Installation complete!"
echo "If running manually (not via Docker), reboot to activate cron jobs."
