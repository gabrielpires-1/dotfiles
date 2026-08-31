#!/bin/bash

# Source constants
. "$(dirname "${BASH_SOURCE[0]}")/constants.sh"

# Aliases for commonly used commands
alias c='clear'
alias ll='ls -lF'
alias la='ls -A'
alias apt-up='sudo apt update && sudo apt upgrade -y'
alias e='exit'

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
alias gf='git fetch origin --prune'
alias gu='git pull'
alias gr='git restore'
alias gb='git branch'

# Git Commands
# Custom function to open a PR from current branch to main | master
gpr() {
  local branch=$(git branch --show-current)
  local title=$(git log -1 --pretty=%s)
  local remote=$(git remote get-url origin)
  local pr_url=""
  local base=""
  local remote_heads=""

  if [[ "$remote" != *"dev.azure.com"* && "$remote" != *"github.com"* ]]; then
    echo "❌ Error: Remote '$remote' is not GitHub or Azure DevOps."
    return 1
  fi

  # Detect the PR target from the remote heads, not from the host.
  # Prefer main, then master. Do not guess from GitHub vs Azure DevOps.
  remote_heads=$(git ls-remote --heads origin 2>/dev/null | awk '{print $2}')

  if echo "$remote_heads" | grep -qx 'refs/heads/main'; then
    base="main"
  elif echo "$remote_heads" | grep -qx 'refs/heads/master'; then
    base="master"
  else
    echo "❌ Error: I cannot open the PR."
    return 1
  fi

  if [[ "$branch" == "$base" ]]; then
    echo "❌ Error: Already on '$base'. Switch to a feature branch first."
    return 1
  fi

  echo "🔀 Opening PR: \"$title\""
  echo "   $branch → $base"

  gp || { echo "❌ Error: 'gp' (push) failed."; return 1; }

  if [[ "$remote" == *"dev.azure.com"* ]]; then
    local org project repo

    if [[ "$remote" == git@ssh.dev.azure.com:* ]]; then
      # SSH format: git@ssh.dev.azure.com:v3/org/project/repo(.git)
      local path="${remote#git@ssh.dev.azure.com:v3/}"
      path="${path%.git}"
      org=$(echo "$path" | cut -d'/' -f1)
      project=$(echo "$path" | cut -d'/' -f2)
      repo=$(echo "$path" | cut -d'/' -f3)
    else
      # HTTPS format: https://dev.azure.com/org/project/_git/repo(.git)
      local path="${remote#*dev.azure.com/}"
      path="${path%.git}"
      org=$(echo "$path" | cut -d'/' -f1)
      project=$(echo "$path" | cut -d'/' -f2)
      repo=$(echo "$path" | cut -d'/' -f4)  # skip "_git" at position 3
    fi

    if [[ -z "$org" || -z "$project" || -z "$repo" ]]; then
      echo "❌ Error: Could not parse Azure DevOps remote URL: $remote"
      return 1
    fi

    local pr_output pr_id
    pr_output=$(az repos pr create \
      --source-branch "$branch" \
      --target-branch "$base" \
      --title "$title" \
      --description "" \
      --query "pullRequestId" -o tsv 2>&1)

    if [[ $? -ne 0 || -z "$pr_output" ]]; then
      echo "❌ Error: Azure DevOps PR creation failed."
      echo "$pr_output"
      return 1
    fi

    pr_id="$pr_output"
    pr_url="https://dev.azure.com/${org}/${project}/_git/${repo}/pullrequest/${pr_id}"
  else
    local pr_output
    pr_output=$(gh pr create --base "$base" --head "$branch" --title "$title" --body "" 2>&1)

    if [[ $? -ne 0 || -z "$pr_output" ]]; then
      echo "❌ Error: GitHub PR creation failed."
      echo "$pr_output"
      return 1
    fi

    pr_url="$pr_output"
  fi

  echo "✅ PR created:"
  echo "$pr_url"
  echo "$pr_url" | xclip -selection clipboard && echo "(copied to clipboard)" || echo "⚠️ Unable to copy to clipboard."
}

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

# History search
hg() {
  history | grep "$@"
}

# Network aliases
alias myip='ip=$(curl -s ifconfig.me) && echo "$ip" && echo "$ip" | xclip -selection clipboard && echo "(copied to clipboard)" || echo "Unable to fetch IP address. Check your internet connection."'