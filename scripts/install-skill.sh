#!/bin/bash
set -e

# AES Skill Installer for Claude Code / OpenCode
# Installs AES as a skill into the appropriate directory

CLAUDE_SKILLS_DIR="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
OPENCODE_SKILLS_DIR="${OPENCODE_SKILLS_DIR:-$HOME/.config/opencode/skills}"

TARGET_CLAUDE="$CLAUDE_SKILLS_DIR/aep-aes"
TARGET_OPENCODE="$OPENCODE_SKILLS_DIR/aep-aes"

INSTALL_CLAUDE=0
INSTALL_OPENCODE=0
UNINSTALL=0
LIST=0

# Parse args
while [[ $# -gt 0 ]]; do
  case $1 in
    --claude|--claude-code)
      INSTALL_CLAUDE=1
      ;;
    --opencode)
      INSTALL_OPENCODE=1
      ;;
    --uninstall)
      UNINSTALL=1
      ;;
    --list)
      LIST=1
      ;;
    --all|--both)
      INSTALL_CLAUDE=1
      INSTALL_OPENCODE=1
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 [--claude] [--opencode] [--all] [--uninstall] [--list]"
      exit 1
      ;;
  esac
  shift
done

# If no flags, show help
if [ $INSTALL_CLAUDE -eq 0 ] && [ $INSTALL_OPENCODE -eq 0 ] && [ $UNINSTALL -eq 0 ] && [ $LIST -eq 0 ]; then
  echo "AES Skill Installer"
  echo ""
  echo "Install AES as a skill for Claude Code and/or OpenCode."
  echo ""
  echo "Usage: $0 [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  --claude       Install for Claude Code (~/.claude/skills)"
  echo "  --opencode     Install for OpenCode (~/.config/opencode/skills)"
  echo "  --all          Install for both"
  echo "  --uninstall    Remove installed skill"
  echo "  --list         Show installed locations"
  echo ""
  echo "Examples:"
  echo "  $0 --claude            # Install for Claude Code only"
  echo "  $0 --opencode          # Install for OpenCode only"
  echo "  $0 --all               # Install for both"
  echo "  $0 --list              # Show where skills are installed"
  echo ""
  echo "Environment variables:"
  echo "  CLAUDE_SKILLS_DIR    Override Claude skills directory"
  echo "  OPENCODE_SKILLS_DIR  Override OpenCode skills directory"
  exit 0
fi

# List installations
if [ $LIST -eq 1 ]; then
  echo "AES Skill Locations:"
  echo ""
  if [ -d "$TARGET_CLAUDE" ]; then
    echo "✅ Claude Code: $TARGET_CLAUDE"
  else
    echo "❌ Claude Code: Not installed"
  fi
  if [ -d "$TARGET_OPENCODE" ]; then
    echo "✅ OpenCode:    $TARGET_OPENCODE"
  else
    echo "❌ OpenCode:    Not installed"
  fi
  exit 0
fi

# Uninstall
if [ $UNINSTALL -eq 1 ]; then
  echo "🗑️  Uninstalling AES skill..."
  rm -rf "$TARGET_CLAUDE"
  rm -rf "$TARGET_OPENCODE"
  echo "✅ Uninstalled"
  exit 0
fi

# Install function
install_skill() {
  local target_dir="$1"
  local target_name="$2"

  echo ""
  echo "📦 Installing AES skill to: $target_dir"

  # Check if already installed
  if [ -d "$target_dir" ]; then
    echo "⚠️  Already installed at $target_dir"
    read -p "Overwrite? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      echo "Skipping $target_name..."
      return
    fi
    rm -rf "$target_dir"
  fi

  # Create directory
  mkdir -p "$target_dir"

  # Copy SKILL.md
  if [ ! -f "SKILL.md" ]; then
    echo "❌ SKILL.md not found in current directory"
    echo "   Run this script from the AES project root"
    exit 1
  fi

  cp SKILL.md "$target_dir/"

  # Copy LICENSE, README if they exist
  if [ -f "LICENSE" ]; then
    cp LICENSE "$target_dir/"
  fi
  if [ -f "README.md" ]; then
    cp README.md "$target_dir/"
  fi

  # Copy scripts/ and template/ directories (useful for development)
  if [ -d "scripts" ]; then
    cp -r scripts "$target_dir/"
  fi
  if [ -d "template" ]; then
    cp -r template "$target_dir/"
  fi
  if [ -d "examples" ]; then
    cp -r examples "$target_dir/"
  fi

  # Copy docs
  if [ -d "docs" ]; then
    cp -r docs "$target_dir/"
  fi

  echo "✅ Installed to $target_dir"
  echo ""
  echo "Usage instructions:"
  echo "  In Claude Code: /load aep-aes"
  echo "  In OpenCode: /skill load aep-aes"
  echo ""
  echo "The skill will be available in: $target_name"
}

# Install for Claude Code
if [ $INSTALL_CLAUDE -eq 1 ]; then
  install_skill "$TARGET_CLAUDE" "aep-aes"
fi

# Install for OpenCode
if [ $INSTALL_OPENCODE -eq 1 ]; then
  install_skill "$TARGET_OPENCODE" "aep-aes"
fi

echo ""
echo "🎉 Installation complete!"
echo ""
echo "To verify, in your LLM interface type:"
echo "  Claude Code: /list-skills"
echo "  OpenCode: /skills"
echo ""
echo "You should see 'aep-aes' in the list."
echo ""
echo "To use: /skill aep-aes or /load aep-aes"
echo ""
echo "To uninstall: $0 --uninstall"
