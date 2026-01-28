# AGENTS.md

## Goal

Port the OverTheWire Bandit wargame to **Nushell** using **Nix** for reproducible builds. The Nix flake must output both a development shell and Docker image with the complete playable game.

## Reference Materials

- `bandit/` - Level goals, commands, and helpful reading from OverTheWire (bandit0.md - bandit34.md, index.md)
- `install.sh` - Original setup logic for each level (lines 124-668)
- `scripts/` - Python listeners and C sources for special levels
- `tasks/prd-nushell-bandit.md` - Full PRD with user stories
- `/home/andre/nixos-config` - a full (complex) nixos config (might be over the top, but has good examples)

## Key Constraints

- Game must use **only nushell** for player interaction
- Nix flake outputs: `devShells.default`, `packages.docker`
- Each level needs: `goal.txt`, `setup.nu`, `check.nu`
- Target nushell 0.100+
- each level needs a test
- all tests should follow the same structure
## Learnings

ALWAYS UPDATE AGENTS.md AND LEARNINGS.md!!!!

When you learn something important while working on this project, update this section with a concise one-liner and add details to `docs/LEARNINGS.md`.

<!-- Add learnings here as: - [Topic]: Brief insight (see docs/LEARNINGS.md#topic) -->

- [Nushell module system]: When calling functions from imported modules with subcommands (e.g., `main setup`), you must use module prefix like `setup main setup` not just `main setup`
- [path exists]: Nushell's `path exists` command takes piped input, not positional arguments - use `$file | path exists` instead of `path exists $file`
- [mkdir]: Nushell's `mkdir` automatically creates parent directories, no `-p` flag needed
- [Regex in where]: When using regex with `where` command on filenames, the `name` field includes full path prefix like `inhere/...`
- [Group-by for counting]: Use `group-by` followed by `transpose` and `sort-by` to count occurrences of lines or elements
- [Binary data handling]: When working with binary files, use `open` and `str find` with regex to extract human-readable strings

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
