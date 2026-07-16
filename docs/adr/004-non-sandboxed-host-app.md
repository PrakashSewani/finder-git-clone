# ADR 004: Non-Sandboxed Host App

## Status

Accepted

## Context

The host app needs to:
- Run `git clone` via `Process`
- Access SSH keys in `~/.ssh/`
- Use credential helpers (1Password, Keychain, GitHub CLI)
- Write to arbitrary directories (clone destination)
- Access git configuration

Sandboxed macOS apps have limited access to these resources.

## Decision

Ship the host app without App Sandbox. The Finder extension remains sandboxed (as required by macOS).

## Consequences

### Positive
- Full access to SSH keys and agents
- Works with all credential helpers
- Can write to any directory the user has permission to access
- Can run git with full functionality
- Consistent with other developer tools (VS Code, iTerm2, Homebrew)

### Negative
- Cannot distribute via Mac App Store
- Requires user trust (but this is expected for developer tools)
- No automatic sandboxing of file access

### Mitigations
- App is open source and auditable
- Uses standard macOS APIs, no suspicious behavior
- Developer tools are expected to have broad system access
- Clear privacy policy and documentation
