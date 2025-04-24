#!/bin/bash

# Prioritize FVM-managed Flutter/Dart in PATH for current session
export PATH="$HOME/.fvm/default/bin:$PATH"

# Create aliases for current session
alias dart="fvm dart"
alias flutter="fvm flutter"

# Show current versions
echo "Using FVM-managed versions:"
fvm dart --version
fvm flutter --version

# Determine shell configuration file
if [ -f "$HOME/.zshrc" ]; then
  SHELL_RC="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
  SHELL_RC="$HOME/.bashrc"
else
  echo "Could not find .zshrc or .bashrc. Please manually add the configuration."
  exit 1
fi

# Check if configuration already exists
if grep -q "# FVM PATH configuration" "$SHELL_RC"; then
  echo "FVM configuration already exists in $SHELL_RC"
else
  # Add configuration to shell RC file
  echo "" >> "$SHELL_RC"
  echo "# FVM PATH configuration" >> "$SHELL_RC"
  echo 'export PATH="$HOME/.fvm/default/bin:$PATH"' >> "$SHELL_RC"
  echo 'alias dart="fvm dart"' >> "$SHELL_RC"
  echo 'alias flutter="fvm flutter"' >> "$SHELL_RC"
  echo "Configuration added to $SHELL_RC"
  echo "Please restart your shell or run 'source $SHELL_RC' to apply changes"
fi 