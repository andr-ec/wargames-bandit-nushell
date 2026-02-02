### Introduction

This is an offline remake of the [Overthewire's wargame Bandit](https://overthewire.org/wargames/bandit/) ported to **Nushell**.
In this remake you will find 40 levels teaching Linux and security skills.

Bandit is great to test your Linux skills and has a nice security related touch.
This version uses **Nushell** for all player interactions.


## Install Instructions

You can run bandit@home with Nix (recommended), Docker, or manually.

### Option 1: Nix (Recommended)

```bash
# Clone the repository
git clone https://github.com/20100dbg/bandit-wargame
cd bandit-wargame

# Enter the development shell
nix develop

# Start playing (launches Nushell)
nu
```

### Option 2: Docker with Nix

Build the Docker image using Nix:
```bash
nix build .#docker
docker load < result
docker run -it bandit-nushell:latest
```

### Option 3: Docker (Traditional)

```bash
# Clone the repository
git clone https://github.com/20100dbg/bandit-wargame

# Build the container
docker build . -t bandit

# Start the container
docker run -d --name bandit -p 2220:22 bandit:latest

# Connect as user bandit0
ssh bandit0@localhost -p 2220
# Password: bandit0
```

### Option 4: Manual Install

> **Warning**: Install in a Virtual Machine, NOT in your daily environment.

```bash
git clone https://github.com/20100dbg/bandit-wargame
sudo apt install xxd git bzip2 gcc netcat-openbsd nmap nushell
sudo ./install.sh
sudo reboot
ssh bandit0@127.0.0.1
```


## How to Play

1. **Navigate to a level directory**: `cd levels/00`
2. **Read the goal**: `open goal.txt` or use the `goal` alias
3. **Solve the challenge**: Use Nushell and Linux commands
4. **Check your answer**: `nu check.nu`
5. **Advance to the next level**

Each level directory contains:
- `goal.txt` - The challenge description
- `setup.nu` - Environment setup script
- `check.nu` - Solution validation script


## Player Documentation

### Getting Started

- **[Quick Start Guide](docs/QUICKSTART.md)** - Get playing in under 5 minutes
- **[Player Guide](docs/PLAYER_GUIDE.md)** - Complete handbook for playing the game
- **[Command Reference](docs/COMMAND_REFERENCE.md)** - All commands you'll need

### Level Information

- **[Level Structure](levels/README.md)** - Overview of level organization and progression

### Additional Resources

- **[Notes Template](docs/NOTES.md)** - Format for tracking your progress
- **[Troubleshooting](docs/TROUBLESHOOTING.md)** - Common issues and solutions
- **[Original Bandit](https://overthewire.org/wargames/bandit/)** - Official game website
- **[bandit/<level>.md](bandit/)** - Original level descriptions


## Development

Run tests:
```bash
nu test-runner.nu
```

Build Docker image with Nix:
```bash
nix build .#docker
```


### Contributors
Thanks to [Kylir](https://github.com/kylir) for writing the initial Dockerfile
