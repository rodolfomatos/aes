#!/bin/bash
set -e

# AES Run Script
# Delegates to language-specific run command

# Load configuration
if [ -f ".aes/config.mk" ]; then
  . .aes/config.mk
fi

if [ -z "$AES_RUN" ] || [ "$AES_RUN" = "echo" ]; then
  echo "❌ AES_RUN not configured for ${AES_LANGUAGE:-unknown}. Edit Makefile or detect-language.sh"
  exit 1
fi

echo "▶️  Executing: $AES_RUN"
eval $AES_RUN
