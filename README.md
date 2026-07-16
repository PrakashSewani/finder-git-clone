# FinderGitClone

Clone Git repositories directly from Finder's right-click context menu.

## Overview

FinderGitClone adds a "Clone Repository..." option to Finder's right-click menu. Right-click any folder, paste a repository URL, and the project is cloned and opened in your editor automatically.

### Before

```
1. Copy repository URL
2. Open Terminal
3. cd ~/Projects
4. git clone <url>
5. cd repo
6. code .
```

### After

```
1. Right-click folder in Finder
2. Select "Clone Repository..."
3. Paste URL
4. Done
```

## Features

- **Native macOS Integration** — Feels like a first-party feature
- **Smart Project Detection** — Automatically detects Xcode, VS Code, Cursor, IntelliJ, and more
- **Auto-Open in Editor** — Opens the project in the right editor
- **Progress Tracking** — Real-time clone progress with cancel support
- **Universal Git Support** — Works with GitHub, GitLab, Bitbucket, Azure DevOps, and any Git server
- **SSH & HTTPS** — Supports all authentication methods
- **Extensible** — Post-clone actions for installing dependencies, copying .env files, etc.

## Installation

### Homebrew (Recommended)

```bash
brew install --cask findergitclone
```

### Download

Download the latest DMG from [Releases](https://github.com/prakashsewani/finder-git-clone/releases).

### Build from Source

```bash
git clone https://github.com/prakashsewani/finder-git-clone.git
cd finder-git-clone
./Scripts/install.sh
```

## Setup

After installation, enable the Finder extension:

1. Open **System Settings**
2. Go to **Privacy & Security** → **Extensions** → **Finder Extensions**
3. Enable **FinderGitClone**

## Usage

1. Right-click any folder in Finder
2. Select "Clone Repository..."
3. Paste a Git URL (HTTPS, SSH, or any Git protocol)
4. Click "Clone"
5. The project is cloned and opened in your editor

## Supported Editors

| Editor | Status |
|--------|--------|
| VS Code | Supported |
| Cursor | Supported |
| Xcode | Supported |
| IntelliJ IDEA | Supported |
| Android Studio | Supported |
| Sublime Text | Supported |
| Fleet | Supported |
| Nova | Supported |

## Supported Git Providers

- GitHub
- GitLab
- Bitbucket
- Azure DevOps
- Self-hosted Git servers
- Any HTTPS or SSH Git repository

## Documentation

- [Vision](docs/vision.md)
- [Architecture](docs/architecture.md)
- [Installation](docs/installation.md)
- [Development](docs/development.md)
- [Contributing](docs/contributing.md)
- [Troubleshooting](docs/troubleshooting.md)
- [Roadmap](docs/roadmap.md)

## Architecture

See [docs/architecture.md](docs/architecture.md) for technical details.

```
Finder Extension (sandboxed)
        │
        │ URL Scheme
        ▼
Host App (non-sandboxed)
        │
        ├── Git Operations
        ├── Project Detection
        ├── Editor Integration
        └── Post-Clone Actions
```

## Requirements

- macOS 14 (Sonoma) or later
- Git installed

## License

MIT License - see [LICENSE](LICENSE)

## Contributing

See [CONTRIBUTING.md](docs/contributing.md) for guidelines.
