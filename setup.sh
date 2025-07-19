#!/usr/bin/env bash

# Setup script for .NET agent installation tools
# Downloads all necessary scripts and makes them executable

set -e

echo "Setting up .NET installation tools for AI agents..."

# Base URL for GitHub raw content
BASE_URL="https://raw.githubusercontent.com/richlander/dotnet-install-for-agents/main/scripts"

# List of scripts to download
scripts=(
    "find_sdk_version.sh"
    "find_exe_versions.sh"
    "find_referenced_versions.sh"
    "find_projects.sh"
)

# Download each script
for script in "${scripts[@]}"; do
    echo "Downloading $script..."
    curl -O "$BASE_URL/$script"
    chmod +x "$script"
done

# Download the official .NET install script
echo "Downloading dotnet-install.sh..."
curl -O https://builds.dotnet.microsoft.com/dotnet/scripts/v1/dotnet-install.sh
chmod +x dotnet-install.sh

echo "Setup complete! All scripts are now available and executable."
echo ""
echo "Quick usage:"
echo "  ./find_projects.sh .          # Get complete project overview"
echo "  ./find_sdk_version.sh .       # Find maximum .NET version needed"
echo "  ./dotnet-install.sh --channel \$(./find_sdk_version.sh .)  # Install required .NET SDK"