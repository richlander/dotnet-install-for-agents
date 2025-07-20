# Running .NET Applications

This guide covers building, running, and publishing .NET applications after you've completed the [installation process](README.md).

## 🏃 Essential Commands

### Building Projects

```bash
# Build the project and get compiler feedback
dotnet build

# Build with minimal output for cleaner logs
dotnet build --verbosity minimal

# Build specific project file
dotnet build path/to/Project.csproj
```

**Key points about `dotnet build`:**
- Compiles the project and produces compiler feedback
- Validates your code changes without running the application
- Downloads NuGet packages if needed
- Creates build artifacts in `bin/` directory

### Running Applications

```bash
# Build and run the project in one command
dotnet run

# Run with command-line arguments (if required by the app)
dotnet run -- arg1 arg2 --flag value

# Run a specific project
dotnet run --project path/to/Project.csproj

# Run with specific configuration
dotnet run --configuration Release
```

**Key points about `dotnet run`:**
- Builds and runs the project automatically
- Great for validating behavior after code changes
- If the app requires command-line parameters, provide them after `--`
- Only works with executable projects (`<OutputType>Exe</OutputType>`)

### Publishing Applications

```bash
# Publish the application for deployment
dotnet publish

# Publish with specific configuration and output directory
dotnet publish --configuration Release --output ./publish

# Publish for specific runtime (cross-platform deployment)
dotnet publish --runtime linux-x64 --self-contained
```

**Key points about `dotnet publish`:**
- Creates a final, deployable version of your application
- Use as the final step before deployment
- Can create self-contained deployments that don't require .NET to be installed on target machines

## 🚀 AOT (Ahead-of-Time) Compilation

For projects with `<PublishAot>true</PublishAot>` in their project file, additional Linux prerequisites are required:

```bash
# Install required packages for AOT compilation on Linux
sudo apt-get update
sudo apt-get install clang zlib1g-dev

# Then publish with AOT
dotnet publish --configuration Release
```

**AOT Requirements:**
- **clang**: C/C++ compiler needed for native code generation
- **zlib1g-dev**: Compression library development files
- These are only needed when `<PublishAot>true</PublishAot>` is enabled in the project

## 🔄 Common Workflow

```bash
# 1. Analyze the project
./_temp/scripts/find_projects.sh .

# 2. Build to check for compilation errors
dotnet build

# 3. Run to test functionality
dotnet run

# 4. If changes look good, create final build
dotnet publish --configuration Release
```

## 🛠️ Advanced Usage

### Multi-Project Solutions

```bash
# Build entire solution
dotnet build MySolution.sln

# Run specific project in solution
dotnet run --project src/WebApp/WebApp.csproj

# Publish specific project
dotnet publish src/WebApp/WebApp.csproj --configuration Release
```

### Testing

```bash
# Run unit tests
dotnet test

# Run tests with detailed output
dotnet test --verbosity normal

# Run tests for specific project
dotnet test tests/MyProject.Tests/MyProject.Tests.csproj
```

### Package Management

```bash
# Restore NuGet packages
dotnet restore

# Add package reference
dotnet add package Newtonsoft.Json

# Remove package reference
dotnet remove package Newtonsoft.Json

# List package references
dotnet list package
```

## 🚨 Troubleshooting

### Common Build Issues

**Issue**: "Project file does not exist"
```bash
# Solution: Check if you're in the right directory
ls -la *.csproj *.sln
# Or find project files
find . -name "*.csproj"
```

**Issue**: "The specified framework is not available"
```bash
# Solution: Check what's installed vs what's needed
dotnet --list-sdks
dotnet --list-runtimes
# Install missing SDK version
./_temp/dotnet-install.sh --channel [VERSION]
```

**Issue**: AOT compilation fails
```bash
# Solution: Install AOT prerequisites
sudo apt-get install clang zlib1g-dev
```

### Common Runtime Issues

**Issue**: "Application requires command line arguments"
```bash
# Solution: Provide arguments after --
dotnet run -- --help
dotnet run -- --config production --port 8080
```

**Issue**: "Entry point not found"
```bash
# Solution: Check project OutputType
grep OutputType *.csproj
# Should be <OutputType>Exe</OutputType> for runnable apps
```

## 📚 Next Steps

- Return to the [main installation guide](README.md)
- Learn about [.NET project structure](https://docs.microsoft.com/dotnet/core/project-sdk/)
- Explore [.NET CLI commands](https://docs.microsoft.com/dotnet/core/tools/)