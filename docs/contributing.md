# Contributing

## Welcome

Thank you for considering contributing to FinderGitClone! This document provides guidelines for contributing.

## Getting Started

1. Fork the repository
2. Clone your fork
3. Create a feature branch: `git checkout -b feature/my-feature`
4. Make your changes
5. Run tests: `swift test`
6. Commit your changes
7. Push to your fork
8. Open a Pull Request

## Development Setup

```bash
# Install prerequisites
brew install xcodegen

# Generate project
xcodegen generate

# Open in Xcode
open FinderGitClone.xcodeproj
```

## Code Guidelines

### Style

- Swift 6 with strict concurrency
- Follow [Swift API Design Guidelines](https://swift.org/documentation/api-guidelines/)
- Use `@MainActor` for UI code
- Prefer `struct` over `class` where possible
- Use `async/await` over callbacks
- Keep functions focused and small

### Testing

- Write unit tests for new features
- Test edge cases and error paths
- Run the full test suite before submitting

### Documentation

- Add doc comments for public APIs
- Update relevant documentation files
- Include code examples where helpful

## Pull Request Process

1. **Describe your changes** clearly in the PR description
2. **Link any related issues**
3. **Include screenshots** for UI changes
4. **Ensure tests pass**
5. **Keep PRs focused** — one feature or fix per PR

## Reporting Issues

- Use GitHub Issues
- Include macOS version, Xcode version, and steps to reproduce
- Include any error messages or logs

## Code of Conduct

Be respectful and inclusive. We're building a tool to help developers — let's make the process enjoyable for everyone.
