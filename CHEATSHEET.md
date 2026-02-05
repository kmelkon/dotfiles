# CLI Cheatsheet

## eza (modern ls)

| Alias | Command | Description |
|-------|---------|-------------|
| `ls` | `eza --icons` | List files with icons |
| `ll` | `eza -l --git --icons` | Long list with git status |
| `la` | `eza -la --git --icons` | Long list including hidden |
| `lt` | `eza --tree --level=2 --icons` | Tree view (2 levels) |

## bat (modern cat)

```bash
bat file.txt              # Syntax highlighted output
bat -p file.txt           # Plain output (no line numbers)
bat -l json file          # Force language
bat --diff file.txt       # Show git diff
```

## fzf (fuzzy finder)

| Keybinding | Action |
|------------|--------|
| `Ctrl+R` | Search command history |
| `Ctrl+T` | Find files in cwd |
| `Alt+C` | cd into directory |

Inside fzf:
- `Ctrl+J/K` or arrows to navigate
- `Enter` to select
- `Tab` to multi-select
- `Ctrl+C` to cancel

## zoxide (smarter cd)

```bash
z foo          # cd to highest ranked dir matching "foo"
z foo bar      # cd to dir matching "foo" and "bar"
zi foo         # Interactive selection with fzf
zoxide query   # Show all tracked directories
```

## lazygit

| Key | Action |
|-----|--------|
| `j/k` | Navigate |
| `space` | Stage/unstage file |
| `c` | Commit |
| `p` | Pull |
| `P` | Push |
| `b` | Branches |
| `?` | Help |
| `q` | Quit |

Alias: `lg`

## zellij

### Mode switching

| Keybinding | Mode |
|------------|------|
| `Ctrl+g` | Lock/unlock |
| `Ctrl+p` | Pane |
| `Ctrl+t` | Tab |
| `Ctrl+n` | Resize |
| `Ctrl+h` | Move |
| `Ctrl+s` | Scroll |
| `Ctrl+o` | Session |
| `Ctrl+b` | Tmux |

### Quick navigation (any mode except locked)

| Keybinding | Action |
|------------|--------|
| `Alt+h/j/k/l` | Move focus |
| `Alt+n` | New pane |
| `Alt+f` | Toggle floating panes |
| `Alt++/-` | Resize |
| `Alt+[/]` | Swap layout |

### Session aliases

| Alias | Session | Layout |
|-------|---------|--------|
| `zwork` | work | mobile-app + webapp-next |
| `zrek` | reklamblad | reklamblad project |
| `zexp` | expenses | expenses project |
| `znot` | notera-cli | notera-cli project |
| `zccd` | claude-code-desktop | claude-code-desktop project |
| `zpause` | pause | pause project |
| `zpin` | pinpoint | pinpoint project |
| `zls` | - | List sessions |

### Other

```bash
zellij attach <session>   # Attach to session
zellij -s <name>          # New named session
zellij -n <layout>        # New session with layout
```
