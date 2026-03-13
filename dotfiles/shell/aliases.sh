#!/bin/bash

# Source constants
. "$(dirname "${BASH_SOURCE[0]}")/constants.sh"

# Aliases for commonly used commands
alias c='clear'
alias ll='ls -alF'
alias la='ls -A'

# Custom alias to navigate to specific directories
alias cdworkspace="cd \"$WORKSPACE_PATH\""