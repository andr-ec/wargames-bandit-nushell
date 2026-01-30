Level Structure

This directory contains all 40 levels for the Bandit wargame, organized by level number.

Directory Structure
-------------------
levels/
├── 00/
│   ├── goal.txt
│   ├── setup.nu
│   └── check.nu
├── 01/
│   ├── goal.txt
│   ├── setup.nu
│   └── check.nu
└── ...
└── 39/
    ├── goal.txt
    ├── setup.nu
    └── check.nu

lib/
├── game.nu      - Password generation functions
├── setup.nu     - User creation and permission helpers
└── check.nu     - Validation and check functions

data/
├── 7_wordlist.txt.gz - Wordlist file for level 7
└── motd.txt - Message of the day

Each level follows this pattern:
- goal.txt: The challenge description for that level
- setup.nu: Nushell script that creates the challenge environment
- check.nu: Nushell script that validates the player's solution

Shared Libraries
----------------
The lib/ directory contains reusable functions used by multiple levels:
- game.nu: Random password generation (32 characters, alphanumeric)
- setup.nu: User creation, permission setting, MOTD creation
- check.nu: Password validation, file validation helpers

Level Progression
-----------------
Levels are organized by difficulty and topic:
- 0-3: Basic file operations (read files, handle special filenames)
- 4-6: File finding with filters (size, permissions, type)
- 7-9: Text search and processing (grep-like operations)
- 10-12: Encoding and compression (base64, rot13, archives)
- 13-18: Network tools (SSH keys, sockets, custom programs)
- 19-22: File systems (suid binaries, permissions, temp files)
- 23-27: Process and scripting (cron jobs, shell scripting)
- 28-34: Git manipulation (branches, tags, history)
- 35-39: Advanced topics (environment variables, system files)

### How to Approach Each Level

**For every level:**
1. Read `goal.txt` carefully - it contains the instructions
2. Check `setup.nu` to understand the environment created
3. Explore the current directory with `ls -la`
4. Look for hidden files and special permissions
5. Use appropriate commands to find the solution
6. Run `nu -c "./check.nu"` to validate your password

**General Tips:**
- Check `ls -la` to see all files including hidden ones (starting with `.`)
- Use `find .` to search for files by name, type, or permissions
- Read files with `cat`, `less`, or `more`
- Change permissions with `chmod`
- Run check script with `nu -c "./check.nu"`
- Advanced levels 31-39 have dedicated `test.nu` files

### Progression Guide

**Beginner (Levels 0-10):** Learn basic file navigation and manipulation
**Intermediate (Levels 11-20):** Learn text processing, system tools, and networking
**Advanced (Levels 21-30):** Learn cryptography, shell scripting, and file systems
**Expert (Levels 31-39):** Complex multi-step problems and binary analysis

See [Player Guide](../docs/PLAYER_GUIDE.md) for detailed instructions.

