#!/bin/bash
set -e

# AES Build Script
# Builds the project

# Load configuration
if [ -f ".aes/config.mk" ]; then
  . .aes/config.mk
fi

if [ -z "$AES_BUILD" ] || [ "$AES_BUILD" = "echo" ]; then
  echo "⚠️  No build configured for ${AES_LANGUAGE:-unknown}"
  echo "Set AES_BUILD in Makefile or scripts/detect-language.sh"
  exit 0
fi

echo "🏗️  Building: $AES_BUILD"
eval $AES_BUILD

echo "✅ Build complete"
