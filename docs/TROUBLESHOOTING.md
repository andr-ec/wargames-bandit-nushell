# Troubleshooting Guide - Bandit Wargame

## Common Issues and Solutions

### General Issues

#### Problem: Cannot run `starter.sh`

**Symptoms:**
```bash
bash: ./starter.sh: No such file or directory
```

**Solutions:**
1. **Make script executable:**
   ```bash
   chmod +x starter.sh
   ```

2. **Check script location:**
   ```bash
   ls -la starter.sh
   pwd
   ```

3. **Ensure in correct directory:**
   ```bash
   cd levels/00
   ```

#### Problem: Permission denied when running commands

**Symptoms:**
```bash
bash: ./check.nu: Permission denied
```

**Solutions:**
1. **Make script executable:**
   ```bash
   chmod +x check.nu
   ```

2. **Run with nu explicitly:**
   ```bash
   nu -c "./check.nu"
   ```

3. **Check if you're in the right user:**
   ```bash
   whoami
   # Should match level username (e.g., bandit0)
   ```

### Navigation Issues

#### Problem: Cannot find directory

**Symptoms:**
```bash
bash: cd: /some/directory: No such file or directory
```

**Solutions:**
1. **Check current directory:**
   ```bash
   pwd
   ```

2. **List all files (including hidden):**
   ```bash
   ls -la
   ```

3. **Use find to locate files:**
   ```bash
   find . -name "*secret*" -type d
   ```

#### Problem: Stuck in nested directory

**Solutions:**
```bash
cd ..                     # Go up one level
cd /                       # Go to root
cd -                       # Go to previous directory
```

### File Access Issues

#### Problem: Permission denied reading file

**Symptoms:**
```bash
cat: secret.txt: Permission denied
```

**Solutions:**
1. **Check permissions:**
   ```bash
   ls -la secret.txt
   ```

2. **Change permissions:**
   ```bash
   chmod 644 secret.txt
   chmod +r secret.txt
   ```

3. **Change ownership:**
   ```bash
   chown $USER secret.txt
   ```

#### Problem: File not found

**Solutions:**
1. **Check if file exists:**
   ```bash
   ls -la
   ```

2. **Search for file:**
   ```bash
   find . -name "*filename*"
   ```

3. **Check case sensitivity:**
   ```bash
   ls -la    # Sometimes filenames are capitalized
   ```

### Test Execution Issues

#### Problem: Check script returns wrong password

**Symptoms:**
```bash
./check.nu
# Returns: Invalid password
```

**Solutions:**
1. **Check if you're in the right level directory:**
   ```bash
   pwd
   ls -la
   cat goal.txt
   ```

2. **Verify password format:**
   ```bash
   # Some passwords might have special characters
   nu -c "./check.nu" | xxd
   ```

3. **Try running with nu explicitly:**
   ```bash
   nu -c "./check.nu"
   ```

#### Problem: Test script not found

**Symptoms:**
```bash
bash: ./test.nu: No such file or directory
```

**Solutions:**
1. **Check if test exists:**
   ```bash
   ls -la test.nu
   ```

2. **Only exists for advanced levels:**
   ```bash
   # Test.nu only exists for levels 31-39
   cd levels/31
   ls -la test.nu
   ```

### Nushell Specific Issues

#### Problem: Command not found

**Symptoms:**
```bash
nu: error: Unknown command
```

**Solutions:**
1. **Ensure you're in nushell shell:**
   ```bash
   nu
   ```

2. **Use built-in commands:**
   ```nu
   ls, cd, pwd, cat, grep, nu -c
   ```

3. **Check Nushell version:**
   ```nu
   $nu.version
   # Should be 0.100 or higher
   ```

#### Problem: Pipe operators not working

**Symptoms:**
```bash
ls | grep "secret"
# Error: unexpected token '|'
```

**Solutions:**
1. **Ensure correct pipe syntax:**
   ```nu
   ls | where name =~ "secret"  # Better in Nushell
   ```

2. **Use Nushell's filtering:**
   ```nu
   ls | grep -E "pattern"
   ```

#### Problem: Variable syntax errors

**Symptoms:**
```bash
$var = "value"
nu: error: ...syntax error...
```

**Solutions:**
1. **Use correct Nushell variable syntax:**
   ```nu
   let var = "value"
   ```

2. **Use proper string quoting:**
   ```nu
   let msg = "hello world"
   ```

### Environment Issues

#### Problem: Docker container not starting

**Symptoms:**
```bash
docker: Error response from daemon: container not found
```

**Solutions:**
1. **Build Docker image first:**
   ```bash
   docker build -t bandit-game .
   ```

2. **Run container properly:**
   ```bash
   docker run --rm -it bandit-game ./starter.sh 0
   ```

3. **Check Docker daemon:**
   ```bash
   sudo systemctl status docker
   ```

#### Problem: Nix shell issues

**Symptoms:**
```bash
nix-shell: command not found
```

**Solutions:**
1. **Install Nix:**
   ```bash
   curl -L https://nixos.org/nix/install | sh
   source /nix/var/nix/profiles/default/etc/profile.d/nix.sh
   ```

2. **Build flake:**
   ```bash
   nix build
   ```

3. **Check flake status:**
   ```bash
   nix flake check
   ```

### Level-Specific Issues

#### Level 1: Cannot find hidden file

**Solutions:**
```bash
ls -la     # Include hidden files
ls -a      # All files including hidden
```

#### Level 2: Permission denied to access file

**Solutions:**
```bash
chmod +r file.txt
chmod 644 file.txt
ls -la
```

#### Level 3: File not found

**Solutions:**
```bash
find . -name "*flag*"
ls -la
```

#### Level 6-10: Finding files with specific permissions

**Solutions:**
```bash
find . -perm -111    # Find executable files
find . -perm -4000   # Find SUID files
find . -perm -2000   # Find SGID files
```

#### Level 11-15: Cannot decode base64

**Solutions:**
```bash
base64 -d file.txt
cat file.txt | base64 -d
```

#### Level 16-20: Process monitoring

**Solutions:**
```bash
ps aux
ps -ef
ps aux | grep <username>
```

#### Level 21-25: Cryptography

**Solutions:**
```bash
# ROT13 encoding/decoding
echo "ROT13" | tr 'A-Za-z' 'N-ZA-Mn-za-m'

# Base64 encoding/decoding
base64 -d file
base64 file
```

#### Level 31-39: Binary file analysis

**Solutions:**
```bash
xxd file
hexdump -C file
strings file
file file
```

### Debugging Tips

#### Use verbose output

```bash
ls -laR
find . -name "*" -ls
grep -r "pattern" .
```

#### Check file sizes

```bash
ls -lh
du -sh .
```

#### List all users

```bash
cat /etc/passwd
```

#### Check system status

```bash
whoami
id
groups
```

### Getting Additional Help

#### Check level documentation

1. Read `goal.txt` thoroughly
2. Check `setup.nu` for environment setup
3. Review `bandit/<level>.md` for original instructions
4. Check `levels/README.md` for level progression

#### Use built-in help

```bash
man <command>           # Command manual
tldr <command>          # Simplified docs
nu --help               # Nushell help
```

#### Common resources

- Bandit website: `bandit.labs.overthewire.org`
- Nushell docs: `nu --help`
- Linux command reference: `man` command
- Project documentation: `docs/` directory

### When All Else Fails

1. **Restart the game:**
   ```bash
   ./starter.sh 0
   ```

2. **Check you're in the right directory:**
   ```bash
   pwd
   ls -la
   ```

3. **Verify level setup:**
   ```bash
   cat goal.txt
   cat setup.nu
   ```

4. **Try the same command in a fresh shell:**
   ```bash
   bash
   nu
   ```

5. **Review your notes:**
   - Check `docs/NOTES.md`
   - Review previous level solutions

---

## Prevention Tips

1. **Always check current directory:**
   ```bash
   pwd && ls -la
   ```

2. **Read goal carefully:**
   ```bash
   cat goal.txt
   ```

3. **Test before committing:**
   ```bash
   nu -c "./check.nu"
   ```

4. **Document what you learn:**
   - Use `docs/NOTES.md`
   - Keep a running list of commands

5. **Verify permissions:**
   ```bash
   ls -la
   ```

---

**Remember:** Most problems are solvable by carefully reading instructions and using basic debugging tools. If you're stuck, review the goal, check permissions, and verify your location.