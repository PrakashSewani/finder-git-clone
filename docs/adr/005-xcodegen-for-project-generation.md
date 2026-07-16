# ADR 005: Use XcodeGen for Project Generation

## Status

Accepted

## Context

We need an Xcode project with multiple targets:
- Host app (macOS SwiftUI application)
- Finder Sync Extension
- Core library (local Swift package)
- Tests

Options:
1. **XcodeGen** — YAML spec → .xcodeproj
2. **Tuist** — Swift-based project generation
3. **Manual .xcodeproj** — Hand-craft PBX format
4. **Xcode project + SPM packages** — Use Xcode's built-in support

## Decision

Use XcodeGen with a `project.yml` specification.

## Consequences

### Positive
- Human-readable YAML specification
- Widely used and well-documented
- Generates clean .xcodeproj files
- Supports local packages, extensions, entitlements
- Can be regenerated at any time
- Low barrier to entry (just `brew install xcodegen`)

### Negative
- Requires XcodeGen to be installed
- Generated .xcodeproj should be committed for convenience
- Some Xcode features may need manual configuration

### Mitigations
- XcodeGen is a single `brew install` away
- Commit both the spec and generated project
- Most features are supported out of the box
