# ADR 002: Use System Git CLI Over libgit2

## Status

Accepted

## Context

We need to clone Git repositories. Two main options:

1. **System `git` CLI** — Execute `git clone` via `Process`
2. **libgit2** — Use SwiftGit2 or similar wrapper around libgit2

## Decision

Use the system `git` CLI via `Process`.

## Consequences

### Positive
- Supports all Git providers out of the box (GitHub, GitLab, Bitbucket, Azure DevOps, self-hosted)
- Works with SSH agents, credential helpers (1Password, macOS Keychain, GitHub CLI)
- Handles Git LFS, submodules, and advanced features automatically
- No linking or dependency management required
- User already has git installed
- Always uses the latest version with security patches

### Negative
- Requires git to be installed (though virtually all macOS developers have it)
- Parsing progress output from CLI is fragile
- Process spawning has overhead (negligible for clone operations)

### Mitigations
- Check for git availability and provide clear error message if missing
- Use robust parsing with fallbacks for progress output
- Process overhead is irrelevant for operations that take seconds to minutes
