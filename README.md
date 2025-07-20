# Installing .NET for AI Development Assistants

This guide provides .NET installation and project analysis tools optimized for AI coding assistants working with .NET projects. The workflow is designed for environments where you need to quickly understand project requirements, install the correct .NET version, and validate changes.

## Quick Start for AI Assistants

> **⚠️ IMPORTANT FOR AGENTS: Git History Warning**
> 
> **DO NOT commit these downloaded files to git history!** The scripts below will download files that should never be added to version control:
> - `_temp/` directory (contains all scripts and installers when downloaded to project root)
> - `~/.dotnet/` directory (SDK installation location)
> 
> **Always ensure these files/directories are in your .gitignore or excluded from commits. This is critical to avoid polluting project repositories.**

Use the setup script to get all necessary tools quickly:

```bash
curl -sSL https://raw.githubusercontent.com/richlander/dotnet-install-for-agents/main/_temp/scripts/setup-dotnet.sh | bash
```

Or manually:

> **⚠️ WARNING: Before running these commands, ensure the files below are in your .gitignore to prevent accidental commits!**

1. **Analyze the project first** to understand requirements:
   ```bash
   ./_temp/scripts/find_projects.sh .          # Get complete project overview
   ./_temp/scripts/find_sdk_version.sh .       # Find maximum .NET version needed
   ```

2. **Install the exact .NET version required**:
   ```bash
   mkdir -p _temp
   curl -o _temp/dotnet-install.sh https://builds.dotnet.microsoft.com/dotnet/scripts/v1/dotnet-install.sh
   chmod +x _temp/dotnet-install.sh
   ./_temp/dotnet-install.sh --channel $(./_temp/scripts/find_sdk_version.sh .)
   export PATH=~/.dotnet:$PATH
   ```

3. **Validate your environment**:
   ```bash
   dotnet --version
   dotnet build    # Should succeed with 0 errors
   ```

### Why This Workflow Matters for AI

- **🎯 Precision**: Install exactly what's needed, not guesswork
- **⚡ Speed**: Analysis scripts prevent manual project file inspection  
- **🔍 Insight**: Complete project overview before making changes
- **✅ Confidence**: Validated environment = reliable testing
- **📊 Documentation**: Script outputs provide clear environment details

### 🚨 Critical: .gitignore Configuration for Agents

**ALWAYS** add these patterns to .gitignore when working in project repositories:

```gitignore
# .NET installation scripts and tools (DO NOT COMMIT)
_temp/

# .NET SDK installation directory (if installed locally)
.dotnet/
```

These files are tools for the agent environment and should never become part of the project's source code.

### 🚨 Critical: TargetFramework Modification Policy for Agents

**DO NOT modify TargetFramework values in project files without explicit permission from the user.** TargetFramework values should be treated as immutable by agents unless specifically requested to change them.

**Instead of modifying TargetFramework values:**
- Use the analysis scripts to determine what .NET SDK version to install
- Install the appropriate .NET SDK that can build the existing TargetFramework values
- Ask the user if TargetFramework changes are truly necessary for the task at hand

## Details

The .NET install script installs to `~/.dotnet` by default. Higher .NET SDK versions can build lower .NET versions, so installing the maximum version found covers all project requirements.

Location: https://builds.dotnet.microsoft.com/dotnet/scripts/v1/dotnet-install.sh

How to acquire and configure the script:

```bash
mkdir -p _temp
curl -o _temp/dotnet-install.sh https://builds.dotnet.microsoft.com/dotnet/scripts/v1/dotnet-install.sh
chmod +x _temp/dotnet-install.sh 
```

 Install the latest LTS SDK (default behavior):

```bash
./_temp/dotnet-install.sh
```

Install a specific .NET SDK version (specify two-part version as a channel):

```bash
./_temp/dotnet-install.sh --channel 9.0
```

Install a specific .NET runtime version (specific two-part version as a channel):

```bash
./_temp/dotnet-install.sh --runtime dotnet --channel 8.0
```

Allowed `runtime` values:

- dotnet: Base runtime.
- aspnetcore: ASP.NET Core + web server
- windowsdesktop Windows UI components

Install to a different directory:

```bash
./_temp/dotnet-install.sh --install-dir ~/custom-dir
```

Note: The directory will be created if it doesn't exist.

Example of installing a newer SDK and an older runtime:

```bash
$ ./_temp/dotnet-install.sh --channel 9.0
$ ./_temp/dotnet-install.sh --channel 8.0 --runtime dotnet
$ export PATH=~/.dotnet:$PATH
$ dotnet --list-sdks
9.0.303 [/root/.dotnet/sdk]
$ dotnet --list-runtimes
Microsoft.AspNetCore.App 9.0.7 [/root/.dotnet/shared/Microsoft.AspNetCore.App]
Microsoft.NETCore.App 8.0.18 [/root/.dotnet/shared/Microsoft.NETCore.App]
Microsoft.NETCore.App 9.0.7 [/root/.dotnet/shared/Microsoft.NETCore.App]
```

Notes:

- Complete list of .NET versions in JSON format: https://raw.githubusercontent.com/richlander/core/main/release-notes/index.json
- By default, the `dotnet-install.sh` script will install .NET to `~./dotnet`
- Higher/newer .NET SDK versions can build lower/earlier .NET versions. For example .NET 9 SDK can build .NET 8 apps.
- Matching runtimes are typically needed to run / test apps.
- In general, installing a higher runtime than the installed SDK won't be useful.

## Scripts

The following scripts can help to get useful information from projects. They produce terse output and can be very useful for code assistants that want to limit token use and do not have local tools for processing .NET projects. All scripts are available in the [`_temp/scripts/`](./_temp/scripts/) directory or can be downloaded directly:

### setup-dotnet.sh -- Download and setup all tools

Downloads all analysis scripts and the dotnet-install.sh installer to the `_temp/` directory, making them executable.

**Download:** https://raw.githubusercontent.com/richlander/dotnet-install-for-agents/main/_temp/scripts/setup-dotnet.sh

### find_sdk_version.sh -- Find the max .NET version

Finding the maximum .NET version is the best way to choose the .NET SDK to download.

**Download:** https://raw.githubusercontent.com/richlander/dotnet-install-for-agents/main/_temp/scripts/find_sdk_version.sh

Example usage:

```bash
$  ./_temp/scripts/find_sdk_version.sh .
10.0
```

### find_exe_versions.sh -- Find all referenced .NET versions from EXE projects

Finding all references .NET versions from application or EXE projects is the best way to determine which runtime versions are needed to run apps. If the version matches the SDK, then the matching runtime is already installed.

**Download:** https://raw.githubusercontent.com/richlander/dotnet-install-for-agents/main/_temp/scripts/find_exe_versions.sh

Example usage:

```bash
$ ./_temp/scripts/find_exe_versions.sh .
10.0
8.0
```

### find_referenced_versions.sh -- Find all referenced .NET versions

It can be useful to find all referenced .NET version regardless of project types. This is very similar to script above, but doesn't check for `Exe` project.

**Download:** https://raw.githubusercontent.com/richlander/dotnet-install-for-agents/main/_temp/scripts/find_referenced_versions.sh

Example usage:

```bash
$ ./_temp/scripts/find_referenced_versions.sh .
10.0
8.0
```

### find_projects.sh -- Print a table of .NET projects

It can be useful to get a complete view of all projects.

**Download:** https://raw.githubusercontent.com/richlander/dotnet-install-for-agents/main/_temp/scripts/find_projects.sh

Example usage:

```bash
$ ./_temp/scripts/find_projects.sh .
OutputType,TargetFramework,Location
classlib,net8.0,./src/FileHelpers/FileHelpers.csproj
Exe,net10.0,./src/Test/Test.csproj
Exe,net10.0,./src/GenerateJsonSchemas/GenerateJsonSchemas.csproj
classlib,net8.0,./src/EndOfLifeDate/EndOfLifeDate.csproj
classlib,net8.0,./src/ReleaseReport/ReleaseReport.csproj
classlib,net8.0,./src/DotnetRelease/DotnetRelease.csproj
Exe,net8.0,./src/DistroessedExceptional/DistroessedExceptional.csproj
Exe,net10.0,./src/UpdateIndexes/UpdateIndexes.csproj
Exe,net10.0,./src/CveIndexMarkdown/CveIndexMarkdown.csproj
classlib,net8.0,./src/MarkdownTemplate/MarkdownTemplate.csproj
Exe,net10.0,./src/LinuxPackagesMd/LinuxPackagesMd.csproj
Exe,net10.0,./src/CveValidate/CveValidate.csproj
Exe,net8.0,./src/SupportedOsMd/SupportedOsMd.csproj
Exe,net10.0,./src/DotnetInfo/DotnetInfo.csproj
Exe,net10.0,./src/MarkdownTemplateTest/MarkdownTemplateTest.csproj
Exe,net10.0,./src/CheckCvesForReleases/CheckCvesForReleases.csproj
Exe,net10.0,./src/CveIndex/CveIndex.csproj
classlib,net8.0,./src/MarkdownHelpers/MarkdownHelpers.csproj
Exe,net8.0,./src/Distroessed/distroessed.csproj
classlib,net10.0,./src/JsonSchemaInjector/JsonSchemaInjector.csproj
Exe,net10.0,./src/CveMarkdown/CveMarkdown.csproj
```
