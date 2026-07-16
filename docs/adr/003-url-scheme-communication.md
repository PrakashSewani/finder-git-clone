# ADR 003: Use URL Scheme for Extension → App Communication

## Status

Accepted

## Context

The Finder extension (sandboxed) needs to communicate with the host app (non-sandboxed). Options:

1. **URL Scheme** — `findergitclone://clone?path=/selected/folder`
2. **NSXPCConnection** — Bidirectional XPC communication
3. **DistributedNotificationCenter** — Fire-and-forget notifications
4. **CFMessagePort** — Low-level Mach port IPC
5. **Shared UserDefaults** — Via App Group container

## Decision

Use URL Scheme for launching/activating the app and passing the selected folder path.

## Consequences

### Positive
- Simplest reliable pattern
- Launches the host app if not running (or activates if already running)
- Standard macOS pattern used by many apps
- No complex setup or configuration
- Works reliably across macOS versions

### Negative
- One-directional (extension → app only)
- Limited data passing (URL encoding constraints)
- Cannot provide real-time progress back to extension

### Mitigations
- One-directional is sufficient (extension's only job is to trigger the app)
- URL encoding handles path data adequately
- Progress is shown in the host app's UI, not in the extension
