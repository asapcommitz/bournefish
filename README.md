# bournefish

**bournefish** is a Fish shell compatibility layer that automatically detects and executes Bash/Zsh commands. When you type a Bash-style command in Fish, bournefish silently wraps it in `bash -c` and runs it, making the transition from Bash/Zsh to Fish seamless.

## Why bournefish?

Switching shells is hard. You've built muscle memory for Bash syntax over years, and Fish's different approach (while better designed) means relearning everything. bournefish bridges this gap by letting you use Bash commands while you gradually learn Fish.

## How It Works

bournefish hooks into Fish's command execution and detects Bash-specific syntax patterns. When it finds them, it automatically wraps your command in `bash -c "..."` behind the scenes. You never see the wrapper, but your Bash commands just work.

**Example:**
```fish
# You type:
VAR=value echo $VAR

# bournefish detects Bash syntax and runs:
bash -c "VAR=value echo $VAR"

# You see: the command works perfectly
```

## Features

- **Automatic Detection**: Recognizes Bash-specific syntax patterns
- **Invisible Execution**: Commands run in Bash without you noticing
- **Zero Configuration**: Works immediately after installation
- **Training Wheels**: Use Bash habits while learning Fish
- **Pure Fish**: No external dependencies besides bash itself

## Detected Patterns

bournefish automatically handles:
- Inline variable assignments (`VAR=value command`)
- Backtick substitution (`` `command` ``)
- Bash-style command substitution (`$(command)`)
- Test bracket syntax (`[ condition ]`)
- Bash-specific builtins and syntax

## Installation

### Via Fisher (Recommended)
```fish
fisher install asapcommitz/bournefish
```

### Manual
```fish
mkdir -p ~/.config/fish/functions ~/.config/fish/completions ~/.config/fish/conf.d
cp functions/bournefish.fish ~/.config/fish/functions/
cp completions/bournefish.fish ~/.config/fish/completions/
cp conf.d/bournefish.fish ~/.config/fish/conf.d/
```

## Usage

Just use Fish normally. bournefish runs in the background and only activates when needed.

```fish
# Bash inline variable assignment (doesn't work in Fish normally)
MY_VAR=hello echo $MY_VAR
# bournefish detects this and runs it in bash

# Backtick substitution
echo `date`
# bournefish handles it

# Regular Fish commands work as normal
set MY_VAR hello
echo $MY_VAR
# bournefish stays out of the way
```

## Disabling bournefish

If you want to disable automatic Bash compatibility:

```fish
# Remove the keybinding
bind \r execute  # Restore default Enter behavior
```

Or comment out the binding in `~/.config/fish/conf.d/bournefish.fish`.

## Relationship to fishglob

**bournefish** is more comprehensive than [fishglob](https://github.com/asapcommitz/fishglob):

- **fishglob**: Translates only glob patterns (for users comfortable with Fish)
- **bournefish**: Handles full Bash command compatibility (for users migrating to Fish)

If you're migrating from Bash, use bournefish. If you already love Fish but miss Bash globs, use fishglob.

## Requirements

- Fish shell
- Bash (for command execution)

## License

[MIT](LICENSE)

---

**Note**: bournefish is a training wheels tool. The goal is to eventually learn Fish syntax and remove bournefish once you're comfortable. Fish's syntax is cleaner and more consistent - bournefish just makes the transition easier.