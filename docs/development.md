# Development

## Prerequisites

- macOS 14+ (Sonoma)
- Xcode 15+
- XcodeGen: `brew install xcodegen`

## Getting Started

```bash
git clone https://github.com/prakashsewani/finder-git-clone.git
cd finder-git-clone

# Install dependencies
brew install xcodegen

# Generate Xcode project
xcodegen generate

# Open in Xcode
open FinderGitClone.xcodeproj
```

## Project Structure

```
├── project.yml              # XcodeGen spec
├── Package.swift            # Core library SPM manifest
├── Sources/                 # Core library code
├── App/                     # Host app code
├── FinderExtension/         # Finder Sync Extension
├── Entitlements/            # App entitlements
├── Tests/                   # Unit tests
├── Scripts/                 # Build & install scripts
├── Homebrew/                # Cask formula
└── docs/                    # Documentation
```

## Building

### Via Xcode

Select the `FinderGitClone` scheme and build (⌘B).

### Via Command Line

```bash
xcodebuild -scheme FinderGitClone -configuration Debug build
```

## Running

1. Build the project
2. Run the `FinderGitClone` target
3. The app will appear in your menu bar

### Testing the Finder Extension

1. Build and run the `FinderExtension` target
2. This launches Finder with the extension loaded
3. Right-click a folder to test the context menu

## Running Tests

```bash
swift test
```

Or in Xcode: ⌘U

## Code Style

- Use Swift 6 with strict concurrency
- Follow Swift API Design Guidelines
- Use `@MainActor` for UI and state management
- Prefer value types (structs, enums) over reference types
- Use Swift concurrency (async/await) over callbacks
- Keep extensions minimal and focused

## Debugging

### Finder Extension

1. Select `FinderExtension` scheme in Xcode
2. Set the executable to `Finder.app`
3. Run — this attaches the debugger to Finder
4. Use `os_log` or Console.app to view extension logs

### Host App

Standard Xcode debugging — set breakpoints, use the debugger, etc.

## Adding a New Feature

### New Project Type Detector

1. Create a new detector in `Sources/FinderGitCloneCore/Detection/Detectors/`
2. Implement the `detect(in:)` method
3. Add it to the `ProjectDetector.detectors` array
4. Add tests

### New Editor

1. Add a new case to the `Editor` enum
2. Set bundle identifier, CLI command, and app names
3. Add compatibility logic in `EditorDetector`
4. Add tests

### New Post-Clone Action

1. Create a struct conforming to `PostCloneAction`
2. Register it in `ActionRegistry.init()`
3. Add tests
