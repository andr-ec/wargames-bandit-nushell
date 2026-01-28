# Learnings

Detailed learnings from building the Nushell Bandit wargame. Referenced from `AGENTS.md`.

## How to Add Learnings

1. Add a concise one-liner to `AGENTS.md` under the Learnings section
2. Add a detailed section here with the same anchor name
3. Format: `## topic-name` for the heading (matches anchor in AGENTS.md)

---

<!-- Add detailed learnings below. Use ## headings that match anchors in AGENTS.md -->

## Nushell Module System

When calling functions from imported modules that have subcommands (e.g., `export def "main setup"`), you must use the module prefix followed by the full command name. For example, if you import a module with `use levels/00/setup.nu`, and the module defines `export def "main setup" []`, you must call it as `setup main setup`, not just `main setup`. This is because `main setup` is a single command name that happens to contain a space, not two separate commands.

### Example
```nu
use levels/00/setup.nu
setup main setup  # Correct
main setup  # Incorrect - this tries to run command "main" with argument "setup"
```

## path exists Command

Nushell's `path exists` command is designed to take piped input, not positional arguments. The correct usage is to pipe the file path to `path exists`, not to pass it as an argument.

### Correct Usage
```nu
# Correct
$file | path exists

# Incorrect
path exists $file
```

## mkdir Command

Nushell's `mkdir` command automatically creates parent directories as needed, so there's no `-p` flag. You can simply use `mkdir path/to/deep/directory` and it will create all intermediate directories.

### Example
```nu
mkdir deep/nested/path  # This works and creates all parent directories
```

## Regex with where Command

When using regex with the `where` command on filenames, be aware that the `name` field often includes a full path prefix. For example, when running `ls inhere`, the filenames in the `name` column will be prefixed with `inhere/`, not just the basename.

### Example
```nu
# When running `ls inhere | where name =~ "..."`
# The name field will be "inhere/...filename", not "...filename"
```

To match just files starting with dots in an `inhere` directory, you might need to adjust your regex accordingly.