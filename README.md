# Dotfiles

A collection of bash configurations and aliases designed to boost your productivity. This repository provides a set of useful shortcuts and functions for common commands, especially for Git and Python workflows.

## Features

- **Git Aliases**: Quick shortcuts for common git commands (`gs`, `ga`, `gc`, `gp`, etc.)
- **Python Management**: Aliases for virtual environments and pip operations (`pyv`, `pyr`, `pyf`)
- **Navigation Aliases**: Dynamic aliases to quickly jump to directories in your workspace
- **Safety Features**: Protection against accidental pushes to main/master branches
- **Customizable Configuration**: Easy-to-personalize settings through `constants.sh`

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/gabrielpires-1/dotfiles.git
   cd dotfiles
   ```

2. Run the installation script:
   ```bash
   bash dotfiles/install.sh
   ```

3. Reload your bash configuration:
   ```bash
   source ~/.bashrc
   ```

That's it! All aliases and functions will now be available in your shell.

## Customization

The `dotfiles/shell/constants.sh` file contains configuration variables that you should customize based on your setup:

### `WORKSPACE_PATH`

This variable defines your main workspace directory. The dynamic workspace aliases are generated based on folders inside this directory.

**Default:**
```bash
WORKSPACE_PATH="$HOME/Desktop/workspace"
```

**How to customize:**

Edit `dotfiles/shell/constants.sh` and change the path to match your actual workspace location:

```bash
# Example: If your projects are in ~/projects
WORKSPACE_PATH="$HOME/projects"

# Example: If your projects are in ~/dev
WORKSPACE_PATH="$HOME/dev"
```

After customizing, reload your shell configuration:
```bash
source ~/.bashrc
```

### Dynamic Workspace Aliases

Once you set `WORKSPACE_PATH`, the system automatically creates aliases for each directory inside it. For example:

If `WORKSPACE_PATH="$HOME/Desktop/workspace"` contains:
- `projects/`
- `dotfiles/`
- `notes/`

You'll automatically get these aliases:
```bash
cdprojects   # Jump to ~/Desktop/workspace/projects
cddotfiles   # Jump to ~/Desktop/workspace/dotfiles
cdnotes      # Jump to ~/Desktop/workspace/notes
```

## Available Aliases

### General
- `c` - Clear terminal
- `ll` - List files in long format
- `la` - List all files (including hidden)

### Navigation
- `cdworkspace` - Jump to your main workspace directory
- `cd{folder_name}` - Dynamic aliases for each folder in workspace

### Git
- `g` - Git command
- `gs` - Git status (short format with branch)
- `ga` - Git add
- `gc` - Git commit with message
- `gsw` - Git switch branch
- `gswc` - Git switch and create new branch
- `gd` - Git diff
- `gl` - Git log (with graph and decorations)
- `gu` - Git pull
- `gp` - Git push (with safety check for main/master)

### Python
- `py` - Python 3
- `pyf` - Freeze dependencies to requirements.txt
- `pyr` - Install dependencies from requirements.txt
- `pyv` - Create and activate virtual environment

### Terraform
- `tf` - Terraform command

## Support for Special Characters

All paths in the configuration are properly quoted to support directory names with:
- Spaces
- Accents and special characters (e.g., `'ÁRea de Trabalho'`)
- Non-ASCII characters in any language

This ensures compatibility across different system locales and languages.
