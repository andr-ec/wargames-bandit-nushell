# Quick Start Guide - Bandit Wargame

## Get Playing in Under 5 Minutes

### Prerequisites

- Git installed
- Nix or Docker installed
- Terminal/Command line access

### Option 1: Using Nix (Recommended)

```bash
# 1. Clone repository
git clone <repository-url>
cd bandit-wargame

# 2. Enter the development shell
nix develop

# 3. Start Nushell and play
nu
cd levels/00
open goal.txt
```

### Option 2: Using Docker

```bash
# 1. Build image
docker build -t bandit-game .

# 2. Run container
docker run -d -p 2220:22 bandit-game

# 3. SSH in as bandit0
ssh bandit0@localhost -p 2220
# Password: bandit0
```

### Option 3: Using Nix Docker Build

```bash
# 1. Build Docker image with Nix
nix build .#docker
docker load < result

# 2. Run the container
docker run -it bandit-nushell:latest
```

### Playing Your First Level

1. **Navigate to level directory**: `cd levels/00`
2. **Read goal**: `open goal.txt`
3. **Try to solve**: Use Nushell commands
4. **Check solution**: `nu check.nu`
5. **Next level**: `cd ../01`

### Key Nushell Commands

```nu
ls              # List files
ls -a           # List hidden files
cd <dir>        # Change directory
open <file>     # Read file contents
where           # Filter data
glob            # Find files by pattern
```

### Next Steps

- Read full **Player Guide** (`docs/PLAYER_GUIDE.md`)
- Check **Level Structure** (`levels/README.md`)
- Start with **Level 0**: `cd levels/00`

---
