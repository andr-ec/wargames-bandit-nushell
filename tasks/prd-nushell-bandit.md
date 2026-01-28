# PRD: Nushell Bandit Wargame

## Overview

A port of the OverTheWire Bandit wargame to teach Linux security concepts using Nushell instead of Bash. This project recreates all 40 levels using Nix for reproducible builds. The Nix flake outputs both a development shell and Docker image containing the complete playable game.

**Reference Materials:**
- `bandit/` - Level goals, suggested commands, and helpful reading (from OverTheWire)
- `install.sh` - Setup logic for each level (lines 124-668)
- `scripts/` - Python listeners and C source files for special levels

## Goals

- Port all 40 levels from `bandit-wargame/install.sh` to use nushell syntax and idioms
- Provide a Nix flake with two primary outputs:
  - `devShells.default` - a shell with nushell and all tools to play the game locally
  - `packages.docker` - a Docker image with the complete game (SSH access like original)
- Include automated test verification for each level via `check.nu` scripts
- Teach nushell commands and pipelines through progressive challenges
- Maintain the same security concepts as the original (file permissions, encoding, networking, git, SUID, cron)

## Quality Gates

These commands must pass for every user story:
- `nix flake check` - Validate flake structure and run checks
- `nix build` - Build the default package successfully
- `nix run .#test-levels` - Run all level test cases

## User Stories

### US-001: Create Nix flake with shell and Docker outputs
**Description:** As a user, I want a Nix flake that provides both a playable shell environment and a Docker image so that I can play the game either way.

**Acceptance Criteria:**
- [ ] Create `flake.nix` with inputs: nixpkgs, flake-utils
- [ ] `devShells.default` provides nushell (0.90+), git, openssh, netcat, nmap, gcc, and required tools
- [ ] `packages.default` builds the game setup script and level data
- [ ] `packages.docker` produces a Docker image with SSH server, nushell as default shell, and all levels configured
- [ ] Docker image exposes port 22, runs setup on first start
- [ ] `checks` output runs the test harness
- [ ] `apps.test-levels` runs all `check.nu` scripts
- [ ] Shell prints welcome message with instructions on entry

### US-002: Create level directory structure and shared libraries
**Description:** As a developer, I want an organized level structure so that levels are easy to maintain and extend.

**Acceptance Criteria:**
- [ ] Create `levels/` directory with subdirectories `00/` through `39/`
- [ ] Each level directory contains: `goal.txt`, `setup.nu`, `check.nu`
- [ ] Copy level goals from `bandit/banditN.md` to corresponding `levels/NN/goal.txt`
- [ ] Create `lib/game.nu` with password generation (`random chars` based, 32 chars)
- [ ] Create `lib/setup.nu` with user creation, permission helpers (mirrors `create_user`, `set_perms` from `install.sh`)
- [ ] Create `lib/check.nu` with validation helpers returning structured `{success: bool, message: string}`
- [ ] Create `data/` directory (copy `7_wordlist.txt.gz`, `motd.txt` from original)
- [ ] All modules use proper nushell `export def` syntax

### US-003: Implement levels 0-3 (Basic file operations)
**Description:** As a player, I want introductory levels so that I can learn basic nushell file commands.

**Reference:** `bandit/bandit0.md` - `bandit/bandit4.md` for goals; `install.sh` lines 134-160 for setup

**Acceptance Criteria:**
- [ ] Level 0: Read password from `readme` file (original: line 136) - teach `open` command
- [ ] Level 1: Handle filename `-` (original: line 143) - teach quoting/escaping
- [ ] Level 2: Handle filename with spaces (original: line 150) - teach string quoting
- [ ] Level 3: Find hidden file `...Hiding-From-You` in `inhere/` (original: line 158) - teach `ls -a`
- [ ] Each `setup.nu` creates the challenge files with correct permissions
- [ ] Each `check.nu` validates player found the correct password

### US-004: Implement levels 4-6 (File finding with filters)
**Description:** As a player, I want file-finding challenges so that I can learn nushell's filtering capabilities.

**Reference:** `bandit/bandit5.md` - `bandit/bandit7.md` for goals; `install.sh` lines 163-238 for setup

**Acceptance Criteria:**
- [ ] Level 4: Find human-readable file among 50 random files (original: lines 165-185) - teach `open`, `describe`, file type detection
- [ ] Level 5: Find file by size (1033 bytes), not executable, human-readable (original: lines 189-230) - teach `ls | where size == 1033`
- [ ] Level 6: Find file owned by bandit7:bandit6, 33 bytes, somewhere on server (original: lines 234-238) - teach recursive search with owner filters
- [ ] Each `check.nu` validates the correct password

### US-005: Implement levels 7-9 (Text search and processing)
**Description:** As a player, I want text processing challenges so that I can learn nushell's string operations.

**Reference:** `bandit/bandit8.md` - `bandit/bandit10.md` for goals; `install.sh` lines 241-283 for setup

**Acceptance Criteria:**
- [ ] Level 7: Find password next to word "millionth" in data.txt (original: lines 242-254) - teach `open | lines | where`
- [ ] Level 8: Find the only unique line in file (original: lines 258-275) - teach `group-by | where count == 1` or `uniq -c`
- [ ] Level 9: Find human-readable strings preceded by `=` in binary data (original: lines 279-283) - teach `strings` equivalent or binary handling
- [ ] Each `check.nu` validates the correct password

### US-006: Implement levels 10-12 (Encoding and compression)
**Description:** As a player, I want encoding challenges so that I can learn nushell's data transformation commands.

**Reference:** `bandit/bandit11.md` - `bandit/bandit13.md` for goals; `install.sh` lines 286-311 for setup

**Acceptance Criteria:**
- [ ] Level 10: Decode base64 data (original: line 288) - teach `decode base64`
- [ ] Level 11: Decode ROT13 (original: line 294) - teach custom command or `str replace` with char mapping
- [ ] Level 12: Decompress nested archives from hexdump (original: lines 299-311) - teach `xxd -r` equivalent, `gunzip`, `bunzip2`, `tar`
- [ ] Each `check.nu` validates the correct password

### US-007: Implement levels 13-16 (SSH and networking)
**Description:** As a player, I want networking challenges so that I can learn about SSH keys and network connections.

**Reference:** `bandit/bandit14.md` - `bandit/bandit17.md` for goals; `install.sh` lines 314-349; `scripts/14_listener_tcp.py`, `scripts/15_listener_ssl.py`, `scripts/16_multiple_listeners.py`

**Acceptance Criteria:**
- [ ] Level 13: Use SSH private key to login as bandit14 (original: lines 316-320) - teach SSH key auth
- [ ] Level 14: Submit password to port 30000 (original: lines 324-327) - implement TCP listener, teach `nc` or nushell networking
- [ ] Level 15: Submit password over SSL to port 30001 (original: lines 331-335) - implement SSL listener, teach `openssl s_client`
- [ ] Level 16: Scan ports 31000-32000, find SSL service returning SSH key (original: lines 339-349) - implement multiple listeners, teach port scanning
- [ ] Network listeners can be Python (as in original) or nushell if feasible
- [ ] Each `check.nu` validates the correct password/key

### US-008: Implement levels 17-20 (Diff and privilege escalation)
**Description:** As a player, I want diff and SUID challenges so that I can learn about file comparison and privilege escalation.

**Reference:** `bandit/bandit18.md` - `bandit/bandit21.md` for goals; `install.sh` lines 352-386; `scripts/19_suid.c`, `scripts/20_tcp_connect.c`

**Acceptance Criteria:**
- [ ] Level 17: Find changed line between passwords.old and passwords.new (original: lines 353-364) - teach `diff` or nushell comparison
- [ ] Level 18: Read readme despite .bashrc logout (original: lines 368-372) - teach SSH command execution
- [ ] Level 19: Use SUID binary bandit20-do (original: lines 376-379, uses `19_suid.c`) - compile C binary, teach SUID concept
- [ ] Level 20: Use suconnect SUID binary with netcat (original: lines 383-386, uses `20_tcp_connect.c`) - compile C binary, teach nc listener + SUID
- [ ] Each `check.nu` validates the correct password

### US-009: Implement levels 21-24 (Cron and scheduled tasks)
**Description:** As a player, I want cron-based challenges so that I can learn about scheduled task exploitation.

**Reference:** `bandit/bandit22.md` - `bandit/bandit25.md` for goals; `install.sh` lines 389-434; `scripts/22_tmp_file.sh`, `scripts/23_tmp_file2.sh`, `scripts/24_script_launcher.sh`, `scripts/25_listener_pin.py`

**Acceptance Criteria:**
- [ ] Level 21: Analyze cronjob_bandit22.sh creating password file (original: lines 390-397, uses `22_tmp_file.sh`)
- [ ] Level 22: Analyze cronjob_bandit23.sh with predictable hash (original: lines 401-407, uses `23_tmp_file2.sh`)
- [ ] Level 23: Exploit cronjob_bandit24.sh script launcher (original: lines 411-421, uses `24_script_launcher.sh`)
- [ ] Level 24: Brute-force 4-digit PIN on port 30002 (original: lines 425-434, uses `25_listener_pin.py`) - teach nushell loops and networking
- [ ] Cron jobs configured in Docker image, simulated in shell mode
- [ ] Each `check.nu` validates the correct password

### US-010: Implement levels 25-26 (SSH and shell escapes)
**Description:** As a player, I want shell escape challenges so that I can learn about restricted environment breakouts.

**Reference:** `bandit/bandit26.md` - `bandit/bandit27.md` for goals; `install.sh` lines 437-462

**Acceptance Criteria:**
- [ ] Level 25: SSH with key to bandit26 which has restricted shell using `more` (original: lines 438-455)
- [ ] Level 26: Escape from `more` shell, use SUID bandit27-do (original: lines 459-462)
- [ ] Configure `/usr/bin/showtext` as restricted shell
- [ ] Each `check.nu` validates the correct password

### US-011: Implement levels 27-31 (Git challenges)
**Description:** As a player, I want git challenges so that I can learn about version control security.

**Reference:** `bandit/bandit28.md` - `bandit/bandit32.md` for goals; `install.sh` lines 467-585; `scripts/31_git_hook`

**Acceptance Criteria:**
- [ ] Level 27: Clone repo, read password from readme (original: lines 468-480)
- [ ] Level 28: Find password hidden in git commit history (original: lines 485-501)
- [ ] Level 29: Find password in git branch `dev` (original: lines 506-534)
- [ ] Level 30: Find password in git tag `secret` (original: lines 538-558)
- [ ] Level 31: Push file to trigger pre-receive hook revealing password (original: lines 563-585, uses `31_git_hook`)
- [ ] Create banditXX-git users with git-shell
- [ ] Each `check.nu` validates the correct password

### US-012: Implement levels 32-39 (Advanced challenges)
**Description:** As a player, I want advanced challenges so that I can master complex exploitation techniques.

**Reference:** `bandit/bandit33.md` - `bandit/bandit34.md` for goals; `install.sh` lines 588-668; `scripts/32_uppershell.c`

**Acceptance Criteria:**
- [ ] Level 32: Escape UPPERCASE shell jail (original: lines 590-598, uses `32_uppershell.c`) - compile C binary
- [ ] Level 33: Find password in environment variable (original: lines 602-609)
- [ ] Level 34: Find recently modified file in `/usr/local/share/man/` (original: lines 613-630)
- [ ] Level 35: Use SUID base64 binary (original: lines 634-638)
- [ ] Level 36: Use SUID find binary (original: lines 642-646)
- [ ] Level 37: Use SUID cp binary (original: lines 650-655)
- [ ] Level 38: Escape python shell (original: lines 658-662)
- [ ] Level 39: Final "Thanks for playing" level (original: lines 666-668)
- [ ] Each `check.nu` validates the correct password

### US-013: Create test harness for level verification
**Description:** As a developer, I want automated tests so that I can verify all levels work correctly.

**Acceptance Criteria:**
- [ ] Create `test-runner.nu` that discovers and executes all `levels/*/check.nu` scripts
- [ ] Each `check.nu` accepts the expected password as argument, returns `{success: bool, message: string}`
- [ ] Test harness reports pass/fail count and which levels failed
- [ ] `nix run .#test-levels` executes test harness in isolated environment
- [ ] Exit code 0 if all pass, non-zero if any fail
- [ ] Tests include setup phase to create level files before checking

### US-014: Write player documentation
**Description:** As a player, I want documentation so that I can understand how to play the game.

**Acceptance Criteria:**
- [ ] README.md with project overview explaining nushell + bandit concept
- [ ] Quick start for Docker: `nix build .#docker && docker load < result && docker run -p 2220:22 bandit-nushell`
- [ ] Quick start for shell: `nix develop` then explanation of local play
- [ ] Explain level progression (bandit0 password is "bandit0", find next password, SSH to next user)
- [ ] Document the `goal` alias and how to check solutions
- [ ] Reference `bandit/index.md` for learning approach and beginner tips
- [ ] No spoilers in documentation

## Functional Requirements

- FR-1: Passwords must be randomly generated 32-character alphanumeric strings (except bandit0 = "bandit0")
- FR-2: Each banditN user can only read `/etc/bandit_pass/bandit(N)` and must find password for bandit(N+1)
- FR-3: File permissions must match original: owner=bandit(N+1), group=banditN, mode=640 for password files
- FR-4: The `check.nu` script must validate by comparing found password against stored password
- FR-5: Docker image must start SSH server and all background listeners (ports 30000, 30001, 30002, 31000-32000)
- FR-6: Docker image must have cron jobs running for levels 21-24, 35
- FR-7: Level goals displayed on login via `/etc/bandit_goal/banditN` and `goal` alias
- FR-8: All nushell scripts must be compatible with nushell 0.100+
- FR-9: SUID binaries (levels 19, 20, 26, 32, 35-37) must be compiled from C sources

## Non-Goals (Out of Scope)

- Web-based interface or UI beyond terminal
- Multiplayer or competitive scoring
- Hint system or built-in walkthroughs
- Automatic level progression (players manually SSH to next level)
- Windows native support (Docker/WSL required)
- Rewriting network listeners in pure nushell (Python acceptable)
- NFS level mentioned in original TODO

## Technical Considerations

- **Reference Implementation:** Level goals from `bandit/*.md`, setup logic from `install.sh`, scripts from `scripts/`
- **Nix Flake Structure:** Use `flake-utils` for multi-system support (x86_64-linux, aarch64-linux)
- **Nushell Version:** Target nushell 0.100+ for stable module system
- **Docker Base:** Use `nixos/nix` or minimal NixOS base, add nushell and openssh
- **C Binaries:** Compile `19_suid.c`, `20_tcp_connect.c`, `32_uppershell.c` via Nix derivation
- **Git Repos:** Create bare repos with pre-configured history using nushell or shell scripts
- **Network Services:** Reuse Python listeners from `scripts/` directory (14, 15, 16, 25)
- **Cron Alternative:** In Docker use cron; in shell mode, document manual testing approach

## Success Metrics

- All 40 levels from original are ported and functional
- All `check.nu` tests pass via `nix run .#test-levels`
- `nix build .#docker` produces working Docker image
- `nix develop` provides working local play environment
- Players can complete all levels using nushell commands

## Open Questions

- Should network listeners be rewritten in nushell for consistency, or keep Python for reliability?
- How to handle cron-dependent levels (21-24, 35) in local shell mode without actual cron?
- Should level solutions be stored encrypted for maintainer reference?
