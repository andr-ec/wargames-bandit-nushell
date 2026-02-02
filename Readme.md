### Introduction

This is an offline remake of the [Overthewire's wargame Bandit](https://overthewire.org/wargames/bandit/) ported to **Nushell**.
In this remake you will find 40 levels teaching Linux and security skills.

Bandit is great to test your Linux skills and has a nice security related touch.
This version uses **Nushell** for all player interactions.


## Project Structure

```
bandit-wargame/
├── game/                 # Game source code
│   ├── levels/          # Level definitions (00-39)
│   ├── lib/             # Shared Nushell libraries
│   └── data/            # Game data files
├── docker/              # Docker infrastructure (bash version)
│   ├── Dockerfile
│   ├── install.sh
│   ├── starter.sh
│   └── scripts/         # Python/C for network levels
├── docs/                # Player documentation
├── reference/           # Original OverTheWire docs
│   └── bandit/
└── tests/               # Test infrastructure
```


## Install Instructions

### Option 1: Nix (Recommended for Nushell version)

```bash
# Clone the repository
git clone https://github.com/20100dbg/bandit-wargame
cd bandit-wargame

# Enter the development shell
nix develop

# Start playing (launches Nushell)
nu
cd game/levels/00
open goal.txt
```

### Option 2: Run Original Bash Version via Nix

```bash
# Build and run the original bash bandit with Docker
nix run .#bash-bandit

# Then connect:
ssh bandit0@localhost -p 2220
# Password: bandit0
```

### Option 3: Docker (Traditional)

```bash
# Clone and build
git clone https://github.com/20100dbg/bandit-wargame
cd bandit-wargame/docker
docker build -t bandit .

# Run container
docker run -d --name bandit -p 2220:22 bandit:latest

# Connect
ssh bandit0@localhost -p 2220
# Password: bandit0
```


## How to Play (Nushell Version)

1. **Navigate to a level directory**: `cd game/levels/00`
2. **Read the goal**: `open goal.txt`
3. **Solve the challenge**: Use Nushell commands
4. **Check your answer**: `nu check.nu`
5. **Advance to the next level**

Each level directory contains:
- `goal.txt` - The challenge description
- `setup.nu` - Environment setup script
- `check.nu` - Solution validation script


## Running Tests

```bash
# Using nix develop shell
nix develop -c nu tests/test-runner.nu

# Or inside the shell
nu tests/test-runner.nu
```


## Player Documentation

- **[Quick Start Guide](docs/QUICKSTART.md)** - Get playing in under 5 minutes
- **[Player Guide](docs/PLAYER_GUIDE.md)** - Complete handbook for playing the game
- **[Command Reference](docs/COMMAND_REFERENCE.md)** - All commands you'll need
- **[Level Structure](game/levels/README.md)** - Overview of level organization


## Additional Resources

- **[Notes Template](docs/NOTES.md)** - Format for tracking your progress
- **[Troubleshooting](docs/TROUBLESHOOTING.md)** - Common issues and solutions
- **[Original Bandit](https://overthewire.org/wargames/bandit/)** - Official game website
- **[Reference Docs](reference/bandit/)** - Original level descriptions


### Contributors
Thanks to [Kylir](https://github.com/kylir) for writing the initial Dockerfile
