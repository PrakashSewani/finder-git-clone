# Architecture

## Overview

FinderGitClone consists of two components:

1. **Host App** — A SwiftUI application that handles UI, git operations, and editor integration
2. **Finder Extension** — A Finder Sync Extension that adds the context menu item

## Communication Flow

```
Finder Context Menu
        │
        ▼
Finder Extension (sandboxed)
        │
        │  URL Scheme: findergitclone://clone?path=/selected/folder
        ▼
Host App (non-sandboxed)
        │
        ├──► Shows Clone Dialog
        ├──► Validates Git URL
        ├──► Runs `git clone`
        ├──► Detects Project Type
        └──► Opens in Editor
```

## Core Library (FinderGitCloneCore)

A Swift package shared between the host app and extension (though the extension is minimal).

### Modules

| Module | Responsibility |
|--------|---------------|
| `Git/` | Git URL parsing, clone operations, progress tracking |
| `Detection/` | Project type detection based on file patterns |
| `Editor/` | Editor detection and project opening |
| `Actions/` | Extensible post-clone action system |
| `Preferences/` | User preferences via App Group shared storage |

## Key Design Decisions

See `/docs/adr/` for detailed Architecture Decision Records.

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Finder integration | Finder Sync Extension | Only API that adds items to context menu |
| Git operations | System git CLI | Full provider support, SSH agents, credential helpers |
| Extension → App communication | URL scheme | Simple, launches app if needed |
| App sandboxing | Non-sandboxed host | Required for git/SSH access |
| Project generation | XcodeGen | Human-readable, widely used |

## Extensibility

### Post-Clone Actions

The `PostCloneAction` protocol allows adding new behaviors:

```swift
protocol PostCloneAction {
    var name: String { get }
    func shouldRun(for result: DetectionResult) -> Bool
    func execute(for result: DetectionResult) async throws
}
```

### Project Detection

Individual detectors implement a simple `detect(in:)` method. New project types can be added without modifying existing code.

### Editor Support

The `Editor` enum is extensible. New editors can be added with their bundle identifier, CLI command, and application detection logic.
