# ADR 001: Use Finder Sync Extension for Context Menu Integration

## Status

Accepted

## Context

We need to add a "Clone Repository..." item to Finder's right-click context menu. macOS provides several APIs for extending Finder:

1. **Finder Sync Extension** — Modern API for adding context menu items, badges, and toolbar buttons
2. **NSServices** — Adds items to the Services submenu (less discoverable)
3. **Automator Quick Actions** — Can appear in context menu but with limited customization
4. **AppleScript/Automation** — Can trigger actions but limited UI capabilities

## Decision

Use the Finder Sync Extension (`FIFinderSyncProtocol`) API.

## Consequences

### Positive
- Context menu item appears directly in Finder's right-click menu (not buried in Services submenu)
- Apple's recommended approach, actively maintained
- Can monitor directories, add badges, and toolbar items
- Proper macOS integration

### Negative
- Extension must be sandboxed (required by macOS)
- Extension runs as a separate process
- Requires user to manually enable in System Settings
- More complex setup than other approaches

### Mitigations
- Host app is non-sandboxed for full git/SSH access
- Communication via URL scheme is reliable and simple
- Clear installation instructions guide users through enabling
