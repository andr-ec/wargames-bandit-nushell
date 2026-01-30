# Command Reference - Nushell Bandit Wargame

## Essential Commands for Each Level Category

### Navigation Commands

```nu
# List files in current directory
ls
ls -la                    # Show all files including hidden ones
ls -R                     # List recursively

# Change directory
cd <directory>            # Enter directory
cd ..                     # Go up one level
cd -                      # Go to previous directory

# Print current location
pwd
```

### File Viewing Commands

```nu
# View file content
cat <file>                # Display entire file
less <file>               # Interactive pager (arrow keys, q to quit)
more <file>               # Page viewer (space to advance)

# View parts of file
head -n <lines> <file>    # First N lines
tail -n <lines> <file>    # Last N lines
tail -f <file>            # Follow file changes in real-time

# Search within files
grep <pattern> <file>     # Search for pattern
grep -r <pattern> <dir>   # Recursive search
grep -i <pattern> <file>  # Case-insensitive search
grep -n <pattern> <file>  # Show line numbers
grep -v <pattern> <file>  # Invert match
```

### File Operations

```nu
# Copy files
cp <source> <destination> # Copy file
cp -r <dir> <dest>        # Copy directory recursively

# Move/rename files
mv <source> <destination> # Move or rename

# Remove files
rm <file>                 # Remove file
rm -r <dir>               # Remove directory recursively
rm -f <file>              # Force remove without confirmation

# Create files
touch <file>              # Create empty file

# Search for files
find <dir> -name "<pattern>"    # Find by name
find <dir> -type <type>         # Find by type (f=file, d=dir)
find <dir> -perm <permissions>  # Find by permissions
```

### Permission Management

```nu
# Change file permissions
chmod <permissions> <file>        # Set exact permissions
chmod +x <file>                   # Make executable
chmod -x <file>                   # Remove executable
chmod 644 <file>                  # rw-r--r--
chmod 755 <file>                  # rwxr-xr-x

# Change ownership
chown <user>:<group> <file>       # Change owner and group
chown <user> <file>               # Change owner only
```

### Compression & Encryption

```nu
# Compress files
tar -czf <archive.tar.gz> <files> # Create gzip archive
tar -xzf <archive.tar.gz>         # Extract gzip archive
gzip <file>                        # Compress file
gunzip <file>                      # Decompress file
zip -r <archive.zip> <files>      # Create zip archive
unzip <archive.zip>                # Extract zip archive

# Decode encoding
base64 -d <file>                   # Decode base64
echo "data" | base64                # Encode base64
xxd <file>                         # View binary in hex
```

### Process Management

```nu
# List processes
ps aux                        # List all processes
ps aux | grep <pattern>       # Search processes

# View system information
uname -a                      # System information
free -h                       # Memory usage
df -h                         # Disk space
du -sh <directory>            # Directory size
```

### Special Nushell Commands

```nu
# Run Nushell commands
nu -c "<command>"             # Execute single command
nu <script.nu>                # Execute Nushell script

# Pipe output to commands
ls | grep <pattern>           # Pipe ls to grep
cat file | lines              # Read lines
```

### Regular Expressions

```nu
# Pattern matching in grep
grep -E "pattern" <file>      # Extended regex
grep -i "pattern" <file>      # Case-insensitive
grep -o "pattern" <file>      # Only show matches

# Common patterns
.*                # Any characters (zero or more)
^[a-z]+$          # Only lowercase letters
[0-9]+            # One or more digits
[a-z]{3}          # Exactly 3 letters
```

### File System Navigation

```nu
# Show all files including hidden
ls -a
ls -la

# Search for files
find . -name "*pattern*"          # Find files with pattern
find . -type f                    # Find all files
find . -type d                    # Find all directories
find . -perm 777                  # Find files with 777 permissions
```

### Binary File Analysis

```nu
# View binary content
xxd <file>                        # Hex dump
hexdump -C <file>                 # Hex dump
strings <file>                    # Extract readable strings
file <file>                       # Identify file type
```

### Advanced Navigation

```nu
# Navigate with tab completion
cd <tab>                         # Complete directory name

# Change to previous directory
cd -

# Display directory tree
tree <directory>                 # Show directory tree
ls -R                            # Recursive listing

# Follow symbolic links
ls -l                           # Show symbolic links
readlink -f <file>              # Resolve symbolic links
```

---

## Level-Specific Command Patterns

### Levels 1-5: Basic Navigation
```nu
ls, cd, pwd, cat, less, more, head, tail, grep
```

### Levels 6-10: File Permissions & Hidden Files
```nu
ls -la, chmod, chown, find -name, find -perm
```

### Levels 11-15: Text Processing
```nu
grep, cat, less, more, head, tail, cut, sort
```

### Levels 16-20: System Information
```nu
ps aux, free -h, df -h, uname -a, whoami
```

### Levels 21-25: Cryptography
```nu
base64, xxd, strings, find, grep
```

### Levels 26-30: Advanced Analysis
```nu
find, grep -r, ls -laR, tar, xargs
```

### Levels 31-39: Complex Problems
```nu
All commands, combined with regular expressions, binary analysis
```

---

## Tips for Using Commands

**Always read the man page:**
```nu
man <command>     # Command manual
tldr <command>    # Simplified documentation
```

**Use tabs for completion:**
```nu
cd <tab>          # Complete directory name
```

**Pipes are powerful:**
```nu
ls | grep "secret"   # Find files containing "secret"
cat file | wc -l     # Count lines in file
```

**Combine commands:**
```nu
find . -name "*.txt" | xargs cat
```

**Test before committing:**
```nu
nu -c "command --options"
```

---

## Common Patterns

**Find files with specific permissions:**
```nu
find . -perm -4000     # Find SUID files
find . -perm -2000     # Find SGID files
find . -perm -0002     # Find sticky bit files
```

**Find files by owner:**
```nu
find . -user <username>
```

**Find files by modification time:**
```nu
find . -mtime -7       # Files modified in last 7 days
find . -mtime +30      # Files modified more than 30 days ago
```

**Search in multiple files:**
```nu
grep -r "pattern" .
grep -R "pattern" .
```

**View multiple files:**
```nu
cat file1 file2 file3
less file1 file2
```

---

## Getting Help

**Built-in help:**
```nu
nu --help              # Nushell help
man <command>          # Command manual
```

**Online resources:**
- Linux command reference
- Nushell documentation
- Bandit level descriptions

---