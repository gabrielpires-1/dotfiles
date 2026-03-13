#!/bin/bash

# Get the absolute path of the directory where THIS script is located
DOTFILES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
BASHRC="$HOME/.bashrc"
ALIASES_PATH="$DOTFILES_DIR/shell/aliases.sh"

echo "Installing Bash Powerup from: $DOTFILES_DIR"

if ! grep -q "$ALIASES_PATH" "$BASHRC"; then
    echo -e "\n# Load custom aliases\n. \"$ALIASES_PATH\"" >> "$BASHRC"
    echo "Installation complete."
else
    echo "Aliases already linked in .bashrc."
fi