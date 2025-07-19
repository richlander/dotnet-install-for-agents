#!/usr/bin/env bash

# setup-dotnet.sh - Download and setup .NET installation scripts for AI agents
# This script downloads all the necessary scripts and dotnet-install.sh

set -e

echo "🔧 Setting up .NET installation tools for AI agent environment..."

# Define the base GitHub raw URL for this repository
REPO_BASE_URL="https://raw.githubusercontent.com/richlander/dotnet-install-for-agents/main"

# Create scripts directory if it doesn't exist
mkdir -p scripts

# Download all helper scripts
echo "📥 Downloading .NET project analysis scripts..."

scripts=(
    "find_sdk_version.sh"
    "find_exe_versions.sh"
    "find_referenced_versions.sh"
    "find_projects.sh"
)

for script in "${scripts[@]}"; do
    echo "  - Downloading $script..."
    curl -sSL "$REPO_BASE_URL/scripts/$script" -o "scripts/$script"
    chmod +x "scripts/$script"
done

# Download the official .NET install script
echo "📥 Downloading official .NET install script..."
curl -sSL "https://builds.dotnet.microsoft.com/dotnet/scripts/v1/dotnet-install.sh" -o "dotnet-install.sh"
chmod +x dotnet-install.sh

# Make all scripts executable
echo "🔐 Making all scripts executable..."
chmod +x scripts/*.sh

echo ""
echo "✅ Setup complete! Available tools:"
echo ""
echo "  Analysis scripts (in ./scripts/):"
echo "    • find_sdk_version.sh      - Find max .NET version needed"
echo "    • find_exe_versions.sh     - Find .NET versions for executable projects"
echo "    • find_referenced_versions.sh - Find all referenced .NET versions"
echo "    • find_projects.sh         - Get complete project overview"
echo ""
echo "  Installation script:"
echo "    • dotnet-install.sh        - Official .NET installer"
echo ""
echo "🚀 Quick start:"
echo "   ./scripts/find_sdk_version.sh .     # Find what .NET version to install"
echo "   ./dotnet-install.sh --channel 9.0  # Install .NET 9.0 SDK"
echo "   export PATH=~/.dotnet:\$PATH         # Add .NET to PATH"
echo ""