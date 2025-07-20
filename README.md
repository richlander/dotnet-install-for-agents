# .NET Installation Guide for AI Development Assistants

This guide provides .NET installation and project analysis tools specifically optimized for AI coding assistants working with .NET projects. The workflow is designed for environments where you need to quickly understand project requirements, install the correct .NET version, and validate changes without prior .NET knowledge.

## 🎯 Quick Start for AI Assistants

**TL;DR**: Run this one-liner to get everything set up:

```bash
curl -sSL https://raw.githubusercontent.com/richlander/dotnet-install-for-agents/main/_temp/scripts/setup-dotnet.sh | bash
```

Then follow the [Automated Workflow](#automated-workflow) section.

## 📋 Prerequisites

- **Linux/macOS environment** (Windows WSL supported)
- **curl** and **bash** available
- **Internet connection** for downloading .NET SDK
- **No prior .NET knowledge required** - this guide assumes you're starting fresh

## 🚀 Automated Workflow

After running the setup script, follow this sequence:

```bash
# 1. Analyze the project to understand requirements
./_temp/scripts/find_projects.sh .          # Get complete project overview
./_temp/scripts/find_sdk_version.sh .       # Find maximum .NET version needed

# 2. Install the exact .NET version required
SDK_VERSION=$(./_temp/scripts/find_sdk_version.sh .)
echo "Installing .NET SDK version: $SDK_VERSION"
./_temp/dotnet-install.sh --channel $SDK_VERSION

# 3. Configure your environment
export PATH=~/.dotnet:$PATH
echo 'export PATH=~/.dotnet:$PATH' >> ~/.bashrc  # Make persistent

# 4. Validate installation
echo "Installed .NET version:"
dotnet --version
echo "Available SDKs:"
dotnet --list-sdks
echo "Available runtimes:"
dotnet --list-runtimes

# 5. Test the project builds
echo "Testing project build..."
dotnet build
```

## 🔧 Manual Installation Steps

If you prefer step-by-step control:

### Step 1: Download Tools

```bash
mkdir -p _temp
curl -o _temp/dotnet-install.sh https://builds.dotnet.microsoft.com/dotnet/scripts/v1/dotnet-install.sh
chmod +x _temp/dotnet-install.sh
```

### Step 2: Analyze Project Requirements

```bash
# Download analysis scripts
curl -sSL https://raw.githubusercontent.com/richlander/dotnet-install-for-agents/main/_temp/scripts/find_sdk_version.sh -o _temp/scripts/find_sdk_version.sh
curl -sSL https://raw.githubusercontent.com/richlander/dotnet-install-for-agents/main/_temp/scripts/find_projects.sh -o _temp/scripts/find_projects.sh
chmod +x _temp/scripts/*.sh

# Analyze the project
./_temp/scripts/find_projects.sh .          # Overview of all projects
./_temp/scripts/find_sdk_version.sh .       # Required SDK version
```

### Step 3: Install .NET SDK

```bash
# Install the required version
./_temp/dotnet-install.sh --channel $(./_temp/scripts/find_sdk_version.sh .)

# Add to PATH
export PATH=~/.dotnet:$PATH
```

## 🧠 Understanding .NET Project Analysis

### Key Concepts for AI Agents

- **TargetFramework**: Specifies the .NET version (e.g., `net8.0`, `net9.0`) - **DO NOT MODIFY** unless explicitly requested
- **OutputType**: `Exe` (applications) vs `classlib` (libraries) - affects which runtime versions you need
- **SDK vs Runtime**: SDK builds projects, Runtime runs applications (SDK includes Runtime)
- **Backward Compatibility**: Newer SDKs can build older projects (install the highest version found)

### Script Output Examples

**find_projects.sh output:**
```
OutputType,TargetFramework,Location
Exe,net8.0,./src/MyApp/MyApp.csproj
classlib,net8.0,./src/MyLibrary/MyLibrary.csproj
```

**find_sdk_version.sh output:**
```
8.0
```

This means: Install .NET 8.0 SDK to build all projects.

## ⚠️ Critical Configuration for Agents

### .gitignore Requirements

**ALWAYS** add these patterns to .gitignore when working in project repositories:

```gitignore
# .NET installation scripts and tools (DO NOT COMMIT)
_temp/

# .NET SDK installation directory (if installed locally)
.dotnet/
```

⚠️ **Important**: These files are temporary tools for the agent environment and should never become part of the project's source code.

### Environment Variables

After installation, ensure .NET is in your PATH:

```bash
# Check if .NET is accessible
which dotnet || echo ".NET not found in PATH"

# Add to current session
export PATH=~/.dotnet:$PATH

# Make permanent (choose one)
echo 'export PATH=~/.dotnet:$PATH' >> ~/.bashrc    # For bash
echo 'export PATH=~/.dotnet:$PATH' >> ~/.zshrc     # For zsh
```

## 🔍 Advanced Installation Options

### Install Specific Versions

```bash
# Install latest LTS (default)
./_temp/dotnet-install.sh

# Install specific SDK version
./_temp/dotnet-install.sh --channel 8.0

# Install runtime only (for running, not building)
./_temp/dotnet-install.sh --runtime dotnet --channel 8.0

# Install ASP.NET Core runtime
./_temp/dotnet-install.sh --runtime aspnetcore --channel 8.0

# Install to custom directory
./_temp/dotnet-install.sh --install-dir ~/my-dotnet
```

### Runtime Types

- **dotnet**: Base runtime for console applications
- **aspnetcore**: ASP.NET Core runtime for web applications  
- **windowsdesktop**: Windows-specific UI components (not typically needed on Linux)

### Version Examples

Installing multiple versions for complex projects:

```bash
# Install .NET 9 SDK (can build .NET 8 and 9 projects)
./_temp/dotnet-install.sh --channel 9.0

# Install .NET 8 runtime (to run .NET 8 applications)
./_temp/dotnet-install.sh --channel 8.0 --runtime dotnet

# Verify installation
dotnet --list-sdks
# Output: 9.0.303 [/root/.dotnet/sdk]

dotnet --list-runtimes
# Output: 
# Microsoft.AspNetCore.App 9.0.7 [/root/.dotnet/shared/Microsoft.AspNetCore.App]
# Microsoft.NETCore.App 8.0.18 [/root/.dotnet/shared/Microsoft.NETCore.App]
# Microsoft.NETCore.App 9.0.7 [/root/.dotnet/shared/Microsoft.NETCore.App]
```

## 🛠️ Available Analysis Scripts

All scripts are available in the [`_temp/scripts/`](./_temp/scripts/) directory. They produce concise output optimized for AI token efficiency.

### setup-dotnet.sh
**Purpose**: Download and setup all tools in one command  
**Download**: https://raw.githubusercontent.com/richlander/dotnet-install-for-agents/main/_temp/scripts/setup-dotnet.sh  
**Usage**: `curl -sSL [URL] | bash`

### find_sdk_version.sh
**Purpose**: Find the maximum .NET version required (determines SDK to install)  
**Download**: https://raw.githubusercontent.com/richlander/dotnet-install-for-agents/main/_temp/scripts/find_sdk_version.sh  
**Usage**: `./_temp/scripts/find_sdk_version.sh .`  
**Output**: `8.0` (single version number)

### find_projects.sh
**Purpose**: Generate a complete table of all .NET projects  
**Download**: https://raw.githubusercontent.com/richlander/dotnet-install-for-agents/main/_temp/scripts/find_projects.sh  
**Usage**: `./_temp/scripts/find_projects.sh .`  
**Output**: CSV format with OutputType, TargetFramework, and Location

### find_exe_versions.sh
**Purpose**: Find .NET versions from executable projects (determines runtime requirements)  
**Download**: https://raw.githubusercontent.com/richlander/dotnet-install-for-agents/main/_temp/scripts/find_exe_versions.sh  
**Usage**: `./_temp/scripts/find_exe_versions.sh .`  
**Output**: List of versions used by applications

### find_referenced_versions.sh
**Purpose**: Find all referenced .NET versions (comprehensive view)  
**Download**: https://raw.githubusercontent.com/richlander/dotnet-install-for-agents/main/_temp/scripts/find_referenced_versions.sh  
**Usage**: `./_temp/scripts/find_referenced_versions.sh .`  
**Output**: List of all .NET versions found in project files

## 🚨 Troubleshooting

### Common Issues and Solutions

**Issue**: "dotnet: command not found"
```bash
# Solution: Add .NET to PATH
export PATH=~/.dotnet:$PATH
# Verify
which dotnet
```

**Issue**: "No project files found"
```bash
# Check if you're in the right directory
pwd
ls -la *.csproj *.sln
# Or search recursively
find . -name "*.csproj" -o -name "*.sln"
```

**Issue**: Build fails with "Framework not found"
```bash
# Check what's installed vs what's needed
dotnet --list-sdks
dotnet --list-runtimes
./_temp/scripts/find_sdk_version.sh .
# Install missing version
./_temp/dotnet-install.sh --channel [VERSION]
```

**Issue**: Permission denied when running scripts
```bash
# Make scripts executable
chmod +x _temp/scripts/*.sh
chmod +x _temp/dotnet-install.sh
```

### Validation Commands

Use these to verify your environment is correctly configured:

```bash
# Basic .NET installation check
dotnet --version

# Project analysis
./_temp/scripts/find_projects.sh . | head -5

# Build test (should complete without errors)
dotnet build --verbosity minimal

# Runtime test (if project has executables)
dotnet run --project [path-to-exe-project]
```

## 🎯 Why This Workflow Matters for AI

- **🎯 Precision**: Install exactly what's needed, no guesswork or over-installation
- **⚡ Speed**: Analysis scripts prevent time-consuming manual project file inspection  
- **🔍 Insight**: Complete project overview before making any changes
- **✅ Confidence**: Validated environment ensures reliable code compilation and testing
- **📊 Documentation**: Script outputs provide clear, parseable environment details
- **🤖 AI-Optimized**: Concise outputs designed for token efficiency in AI workflows

## 📚 Additional Resources

- **Complete .NET versions list**: https://raw.githubusercontent.com/richlander/core/main/release-notes/index.json
- **.NET installation script source**: https://builds.dotnet.microsoft.com/dotnet/scripts/v1/dotnet-install.sh
- **.NET documentation**: https://docs.microsoft.com/dotnet/

## 💡 Pro Tips for AI Agents

1. **Always analyze before installing** - Use the scripts to understand project requirements first
2. **Install the highest version found** - Newer SDKs are backward compatible
3. **Verify after installation** - Run `dotnet build` to ensure everything works
4. **Respect TargetFramework values** - Don't change them unless specifically requested
5. **Clean up when done** - Remove `_temp/` directory if it won't be needed again
6. **Use parallel builds** - `dotnet build --parallel` for faster compilation of multi-project solutions
