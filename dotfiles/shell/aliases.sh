#!/bin/bash

# Source constants
. "$(dirname "${BASH_SOURCE[0]}")/constants.sh"

# Aliases for commonly used commands
alias c='clear'
alias ll='ls -lF'
alias la='ls -A'
alias apt-up='sudo apt update && sudo apt upgrade -y'

# Custom alias to navigate to specific directories
alias cdworkspace="cd \"$WORKSPACE_PATH\""

# Git aliases
alias g='git'
alias gs='git status -s -b'
alias ga='git add'
alias gc='git commit -m'
alias gsw='git switch'
alias gswc='git switch -c'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate'
alias gu='git pull'

# Custom function to prevent accidental pushes to main/master
gp() {
  local branch=$(git branch --show-current)
  
  if [[ "$branch" == "main" || "$branch" == "master" ]]; then
    echo "❌ Error: Direct push to '$branch' blocked for security!"
    echo "Use 'git push' manually if you really need to do this."
    return 1
  fi

  git push -u origin "$branch"
}

# Python aliases
alias py='python3'
alias python='python3'
alias pyf='pip freeze > requirements.txt'
alias pyr='pip install -r requirements.txt'

pyvenv() {
  if [ ! -d venv ]; then
    python3 -m venv venv
    echo "✓ Virtual environment created"
  else
    echo "✓ Virtual environment already exists"
  fi
  echo "Activating virtual environment..."
  source venv/bin/activate
  echo "✓ Virtual environment activated"
}

# Terraform aliases
alias tf='terraform'

# Dynamic aliases for workspace directories
# Creates aliases like cd{folder_name} for each folder in WORKSPACE_PATH
_create_workspace_aliases() {
  if [ ! -d "$WORKSPACE_PATH" ]; then
    echo "⚠ Workspace path does not exist: $WORKSPACE_PATH"
    return
  fi

  for dir in "$WORKSPACE_PATH"/*/; do
    folder_name=$(basename "$dir")
    
    alias_name="cd${folder_name}"
    
    alias "$alias_name=cd \"$dir\""
  done
}

# Run on shell initialization
_create_workspace_aliases
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfd='terraform destroy'

# Network aliases
alias myip='curl ifconfig.me && echo || echo "Unable to fetch IP address. Check your internet connection."'