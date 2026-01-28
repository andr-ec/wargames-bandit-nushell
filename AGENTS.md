# AGENTS.md

## Goal

Port the OverTheWire Bandit wargame to **Nushell** using **Nix** for reproducible builds. The Nix flake must output both a development shell and Docker image with the complete playable game.

## Reference Materials

- `bandit/` - Level goals, commands, and helpful reading from OverTheWire (bandit0.md - bandit34.md, index.md)
- `install.sh` - Original setup logic for each level (lines 124-668)
- `scripts/` - Python listeners and C sources for special levels
- `tasks/prd-nushell-bandit.md` - Full PRD with user stories

## Key Constraints

- Game must use **only nushell** for player interaction
- Nix flake outputs: `devShells.default`, `packages.docker`
- Each level needs: `goal.txt`, `setup.nu`, `check.nu`
- Target nushell 0.100+

## Learnings

When you learn something important while working on this project, update this section with a concise one-liner and add details to `docs/LEARNINGS.md`.

<!-- Add learnings here as: - [Topic]: Brief insight (see docs/LEARNINGS.md#topic) -->

## Landing the Plane (Session Completion)

**When ending a work session**, you MUST complete ALL steps below. Work is NOT complete until `git push` succeeds.

**MANDATORY WORKFLOW:**

1. **File issues for remaining work** - Create issues for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **PUSH TO REMOTE** - This is MANDATORY:
   ```bash
   git pull --rebase
   bd sync
   git push
   git status  # MUST show "up to date with origin"
   ```
5. **Clean up** - Clear stashes, prune remote branches
6. **Verify** - All changes committed AND pushed
7. **Hand off** - Provide context for next session

**CRITICAL RULES:**
- Work is NOT complete until `git push` succeeds
- NEVER stop before pushing - that leaves work stranded locally
- NEVER say "ready to push when you are" - YOU must push
- If push fails, resolve and retry until it succeeds
