# Player Guide - Nushell Bandit Wargame

## Welcome to the Bandit Wargame

This is a collection of 40 programming and security learning challenges designed to teach you about Linux, command-line operations, and security concepts. Each level introduces new skills and gradually builds your expertise.

## Table of Contents

1. [Getting Started](#getting-started)
2. [How to Play](#how-to-play)
3. [Testing Your Solutions](#testing-your-solutions)
4. [Progression Guide](#progression-guide)
5. [Best Practices](#best-practices)
6. [Getting Help](#getting-help)

---

## Getting Started

### Quick Installation

#### Option 1: Using Nix (Recommended)

```bash
# Clone the repository
git clone <repository-url>
cd bandit-wargame

# Build and enter the development shell
nix-shell

# Start playing from level 0
./starter.sh 0
```

#### Option 2: Using Docker

```bash
# Build the Docker image
docker build -t bandit-game .

# Run the container for level 0
docker run --rm -it bandit-game ./starter.sh 0
```

#### Option 3: Local Setup with Nushell

If you have Nushell installed:

```bash
# Clone the repository
git clone <repository-url>
cd bandit-wargame

# Open Nushell shell
nu

# Navigate to levels directory
cd levels

# Start playing
./starter.sh 0
```

### First Steps

1. **Enter a Level**: `./starter.sh <level-number>`
2. **Read the Goal**: Open `goal.txt` in the level directory
3. **Read the Setup**: Check `setup.nu` to understand the environment
4. **Try to Solve**: Use `check.nu` to validate your password
5. **Move Forward**: When you find the password, move to the next level

---

## How to Play

### Level Structure

Each level directory contains:
```
level/
├── goal.txt      # The challenge description
├── setup.nu      # Environment setup script
├── check.nu      # Password validation script
└── test.nu       # Test script (advanced levels)
```

### Solving a Level

**Step 1: Understand the Goal**

Read `goal.txt` carefully. It tells you what you need to do and where to find the password.

**Step 2: Explore the Environment**

The setup creates a controlled environment with:
- A dedicated user for the level
- Specific files and directories
- Unique permissions

**Step 3: Apply Your Skills**

Use Linux commands and Nushell to find the solution:
- Navigate directories
- Read files
- Change permissions
- Decode ciphers
- Extract information from binary data

**Step 4: Validate Your Solution**

Run the check script:

```bash
nu -c "./check.nu"
```

The script will verify if your password is correct and help you if you're stuck.

**Step 5: Advance**

Enter the next level with your password:

```bash
./starter.sh <next-level>
```

### Common Commands

**Navigation:**
```nu
ls                  # List files
cd <directory>      # Change directory
pwd                 # Print working directory
```

**File Operations:**
```nu
cat <file>          # Read file content
less <file>         # Interactive file viewer
head <file>         # First lines of file
tail <file>         # Last lines of file
grep <pattern> <file> # Search for text
```

**Permission Changes:**
```nu
chmod +x <file>     # Make executable
chmod 644 <file>    # Set permissions
chown <user>:<group> <file> # Change owner
```

**Special Operations:**
```nu
nu -c "<command>"  # Run Nushell command
```

---

## Testing Your Solutions

### Using the Check Script

The `check.nu` script in each level directory:
- Validates your password
- Provides hints if incorrect
- Shows the correct password if all attempts fail

**Usage:**
```bash
nu -c "./check.nu"
```

**Expected Output:**
- Correct password: Password accepted
- Incorrect password: Retry or see hints
- Wrong level: Invalid level number

### Running Individual Level Tests

For advanced levels (31-39), run the dedicated test:

```bash
nu -c "./test.nu"
```

### Debugging Tips

**If stuck, try:**
1. Review `goal.txt` again for clues
2. Check `setup.nu` to understand environment
3. Look at similar levels for patterns
4. Use `ls -la` to check permissions
5. Search for hidden files with `ls -a`

**Using Nushell effectively:**
```nu
# Filter and search
ls | where name =~ "secret" | get name

# Count occurrences
cat file.txt | lines | group-by | transpose | sort-by _1

# Decode strings
open file | str find -r "word"

# Execute commands
nu -c "command --options"
```

---

## Progression Guide

### Level Categories

**Levels 1-5: Basic Commands**
- Learn file navigation and viewing
- Simple permission changes
- Introduction to environment variables

**Levels 6-10: File Manipulation**
- Finding hidden files
- Permission analysis
- Special file types

**Levels 11-15: Text Processing**
- Pattern matching
- File compression/decompression
- Base64 encoding/decoding

**Levels 16-20: System Analysis**
- Process monitoring
- Network information
- User management

**Levels 21-25: Cryptography**
- Basic ciphers (ROT13, base64)
- Simple encryption/decryption
- Special encoding methods

**Levels 26-30: Advanced Commands**
- Data analysis
- Pattern recognition
- File system exploration

**Levels 31-39: Advanced Challenges**
- Complex encryption
- Binary file analysis
- Multi-step problems
- Network exploration

### Learning Resources

**Documentation to Read:**
- `bandit/index.md` - Original Bandit game introduction
- `levels/README.md` - Level structure overview
- `bandit/<level-number>.md` - Original level descriptions

**Online Resources:**
- `bandit.labs.overthewire.org` - Official Bandit website
- Linux command-line documentation
- Nushell documentation

---

## Best Practices

### Taking Notes

Create a dedicated notes file for tracking your progress:

**Notes Template (`my-notes.md`):**
```markdown
# Bandit Wargame Notes

## Level 0
**Password:** bandit0
**Skills Learned:** Basic navigation, file listing
**Tools Used:** ls, cd, pwd, cat, less, more

## Level 1
**Password:** bandit1
**Skills Learned:** Hidden files, grep
**Tools Used:** ls -a, grep

## Level 2
**Password:** bandit2
**Skills Learned:** File permissions, wildcards
**Tools Used:** chmod, ls -la

... (continue for all levels)
```

### Development Workflow

**1. Read the Challenge**
- Understand what you need to accomplish
- Identify required skills

**2. Practice Skills**
- Use simple commands to explore
- Experiment in the level environment

**3. Test Solutions**
- Use `check.nu` to validate
- Fix errors before proceeding

**4. Document Learning**
- Record what you learned
- Note useful commands

**5. Move Forward**
- Apply skills to new challenges
- Build on previous knowledge

### Common Pitfalls

**❌ Don't:**
- Share passwords with others
- Copy solutions directly
- Skip reading the goal
- Ignore permission requirements

**✅ Do:**
- Read every word of the goal
- Try to understand the solution
- Learn from each level
- Take detailed notes

---

## Getting Help

### Internal Resources

**In the Game:**
1. Read `goal.txt` carefully
2. Check `setup.nu` for environment clues
3. Run `check.nu` to validate attempts
4. Look at similar levels

**Documentation:**
- `levels/README.md` - Level progression
- `docs/COMMAND_REFERENCE.md` - Command examples
- `docs/TROUBLESHOOTING.md` - Common issues

### External Resources

**Official Bandit:**
- Website: `bandit.labs.overthewire.org`
- Level descriptions: `bandit/<level>.md`

**Linux Command Reference:**
- `man <command>` - Command manual
- `tldr <command>` - Simplified documentation

**Nushell:**
- `nu --help` - Built-in help
- Official Nushell documentation

### When You're Stuck

**Checklist before asking for help:**
- [ ] Read the goal carefully
- [ ] Check all files in the level directory
- [ ] Use `ls -la` to find hidden items
- [ ] Try different permission settings
- [ ] Search for keywords in files
- [ ] Run `check.nu` multiple times

**Seek Help From:**
- Level description in `bandit/<level>.md`
- Online forums and communities
- Your notes from previous levels
- Colleagues or peers

---

## Tips for Success

1. **Start Slow**: Don't rush through levels
2. **Learn Every Level**: Each one teaches something new
3. **Keep Notes**: Document your learning process
4. **Ask Questions**: Don't be afraid to seek help
5. **Practice Commands**: Use each command multiple times
6. **Analyze Setup**: Understand how the environment is created
7. **Review Solutions**: After solving, review how it works
8. **Teach Others**: Explain solutions to reinforce learning

## Conclusion

The Bandit Wargame is designed to take you from a complete beginner to a capable Linux/Nushell user. Take your time, learn each concept, and enjoy the journey. The challenges become progressively harder, but each level builds on the skills from the previous ones.

**Remember**: The goal isn't just to find passwords—it's to learn essential skills that will serve you throughout your programming and security career.

Good luck, and happy learning!

---