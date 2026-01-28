# Level Structure Documentation

## Overview

The game is organized into 40 levels, each in a separate directory under `levels/`. Each level contains:

- `goal.txt` - The challenge description
- `setup.nu` - Nushell script to create the level's challenge files and users
- `check.nu` - Nushell script to validate the player's solution

## Directory Structure

```
levels/
├── 00/
│   ├── goal.txt
│   ├── setup.nu
│   └── check.nu
├── 01/
│   ├── goal.txt
│   ├── setup.nu
│   └── check.nu
├── 02/
│   ├── goal.txt
│   ├── setup.nu
│   └── check.nu
├── ...
└── 39/
    ├── goal.txt
    ├── setup.nu
    └── check.nu
```

## Level Files

### goal.txt
Contains the level's objective in human-readable form. Players read this to understand what they need to accomplish.

### setup.nu
Creates the level's environment including:
- User accounts (if applicable)
- Challenge files with specific names and permissions
- Password storage for the next level
- Special directories or configurations

Key setup patterns:
- Password generation using `lib/game.nu:generate-password-random`
- User creation using `lib/setup.nu:create-user`
- File creation using `lib/setup.nu:create-readme`, `lib/setup.nu:create-file-with-size`, etc.
- Permission setting using `lib/setup.nu:set-permissions`

### check.nu
Validates the player's solution. Accepts the player's guessed password as input and returns:
```nushell
{
    success: bool,
    message: string
}
```

## Shared Libraries

### lib/game.nu
Utility functions for password generation:
- `generate-password [length]` - Generates password by rotating through character set
- `generate-password-random []` - Generates truly random 32-character password

### lib/setup.nu
User and file creation utilities:
- `create-user [username, password, home_dir, shell]` - Creates system user
- `create-group [group_name]` - Creates system group
- `set-permissions [file_path, owner, group, mode]` - Sets file permissions
- `create-readme [file_path, content]` - Creates readable text file
- `create-hidden-file [file_path, content]` - Creates hidden file
- `create-file-with-size [file_path, size_bytes, content]` - Creates specific file size
- `create-folder [folder_path]` - Creates directory

### lib/check.nu
Validation utilities:
- `validate-password [password, expected_password]` - Validates password matches
- `validate-file-exists [file_path, required]` - Checks if file exists
- `validate-file-content [file_path, expected_content, exact]` - Validates file content
- `validate-password-file [file_path, owner, group, mode]` - Validates password file structure
- `validate-hidden-file [file_path, content?]` - Validates hidden file

## Level Implementation Pattern

### Basic Pattern (Levels 0-3)

```nushell
# setup.nu
export def run-setup [] {
    use lib/game.nu

    let level_password = (generate-password-random)

    create-user "bandit1" $level_password
    create-readme (path expand ~)/bandit1/readme $level_password

    echo $"Password for bandit1: ($level_password)"
    return $level_password
}

export def run-check [input: string] {
    use lib/check.nu

    let password = open (path expand ~)/bandit1/readme | str trim
    validate-password $input $password
}

# check.nu
export def check-password [input: string] {
    use lib/check.nu

    try {
        let password = open (path expand ~)/bandit1/readme | str trim
        validate-password $input $password
    } catch {
        {
            success: false,
            message: "Error reading password file"
        }
    }
}
```

### Advanced Pattern (Levels 4-39)

For more complex levels, the pattern remains similar but setup.nu may:
- Create multiple files with specific constraints
- Use special file naming conventions
- Set specific permissions
- Create nested directories
- Use different file content validation approaches

## Implementation Status

### Completed Levels
- **00**: Starting point - bandit0 password is "bandit0"
- **01**: File reading (readme)
- **02**: Filename with hyphen (-)
- **03**: Hidden file (Hiding-From-You)

### To Implement (Levels 4-39)
See PRD sections US-003 through US-012 for detailed level specifications:
- US-003: Levels 4-6 (File finding with filters)
- US-004: Levels 7-9 (Text search and processing)
- US-005: Levels 10-12 (Encoding and compression)
- US-006: Levels 13-16 (SSH and networking)
- US-007: Levels 17-20 (Diff and privilege escalation)
- US-008: Levels 21-24 (Cron and scheduled tasks)
- US-009: Levels 25-26 (SSH and shell escapes)
- US-010: Levels 27-31 (Git challenges)
- US-011: Levels 32-39 (Advanced challenges)

## Testing

Each level can be tested by:
1. Running the setup script
2. Attempting to solve the challenge
3. Running the check script with the guessed password

Example:
```bash
# Test level 1
nushell levels/01/setup.nu
# Now play as bandit1, solve the challenge, then test
nushell levels/01/check.nu "your_answer"
```

## Integration with Test Harness

The `test-runner.nu` script will discover and execute all `check.nu` scripts, running them in the appropriate environment.
