#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Create backup directory
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

backup_and_link() {
    local src="$1"
    local dest="$2"

    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        mkdir -p "$BACKUP_DIR"
        echo "Backing up $dest to $BACKUP_DIR/"
        mv "$dest" "$BACKUP_DIR/"
    elif [ -L "$dest" ]; then
        rm "$dest"
    fi

    mkdir -p "$(dirname "$dest")"
    ln -s "$src" "$dest"
    echo "Linked $src -> $dest"
}

# Zsh
backup_and_link "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

# Zellij
backup_and_link "$DOTFILES_DIR/zellij/config.kdl" "$HOME/.config/zellij/config.kdl"

# Zellij layouts
for layout in "$DOTFILES_DIR/zellij/layouts/"*.kdl; do
    layout_name=$(basename "$layout")
    backup_and_link "$layout" "$HOME/.config/zellij/layouts/$layout_name"
done

# Claude Code
backup_and_link "$DOTFILES_DIR/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
backup_and_link "$DOTFILES_DIR/claude/settings.json" "$HOME/.claude/settings.json"
backup_and_link "$DOTFILES_DIR/claude/settings.local.json" "$HOME/.claude/settings.local.json"
backup_and_link "$DOTFILES_DIR/claude/statusline-command.sh" "$HOME/.claude/statusline-command.sh"
backup_and_link "$DOTFILES_DIR/claude/commands" "$HOME/.claude/commands"
backup_and_link "$DOTFILES_DIR/claude/skills" "$HOME/.claude/skills"
backup_and_link "$DOTFILES_DIR/claude/scripts" "$HOME/.claude/scripts"

echo ""
echo "Done! Restart your shell or run: source ~/.zshrc"
