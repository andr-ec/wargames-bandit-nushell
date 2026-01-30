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

# 2. Enter the game shell
nix-shell

# 3. Start level 0
./starter.sh 0
```

### Option 2: Using Docker

```bash
# 1. Build image
docker build -t bandit-game .

# 2. Run level 0
docker run --rm -it bandit-game ./starter.sh 0
```

### Playing Your First Level

1. **Navigate to level directory**: `cd levels/00`
2. **Read goal**: Open `goal.txt`
3. **Try to solve**: Use Linux/Nushell commands
4. **Check solution**: `nu -c "./check.nu"`
5. **Next level**: `./starter.sh 1`

### Key Commands

```nu
ls, cd, pwd, cat, grep, chmod, nu -c <command>
```

### Next Steps

- Read full **Player Guide** (`docs/PLAYER_GUIDE.md`)
- Check **Level Structure** (`levels/README.md`)
- Start with **Level 0**: `./starter.sh 0`

---