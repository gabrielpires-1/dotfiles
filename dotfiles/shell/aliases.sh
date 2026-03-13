#!/bin/bash

# Source constants
. "$(dirname "${BASH_SOURCE[0]}")/constants.sh"

# Aliases for commonly used commands
alias c='clear'
alias ll='ls -lF'
alias la='ls -A'

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



