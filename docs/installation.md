# Installation

## Requirements

- macOS 14 (Sonoma) or later
- Git (installed via Xcode Command Line Tools or separately)

## Option 1: Homebrew (Recommended)

```bash
brew install --cask findergitclone
```

## Option 2: Download DMG

1. Download the latest DMG from [Releases](https://github.com/prakashsewani/finder-git-clone/releases)
2. Open the DMG
3. Drag `FinderGitClone.app` to `/Applications`
4. Enable the Finder extension (see below)

## Option 3: Build from Source

```bash
git clone https://github.com/prakashsewani/finder-git-clone.git
cd finder-git-clone
./Scripts/install.sh
```

## Enabling the Finder Extension

After installation, you must enable the Finder extension:

1. Open **System Settings**
2. Go to **Privacy & Security** → **Extensions** → **Finder Extensions**
3. Enable **FinderGitClone**

## Verifying Installation

1. Right-click any folder in Finder
2. You should see "Clone Repository..." in the context menu
3. Click it to open the clone dialog

## Uninstalling

### Via Homebrew

```bash
brew uninstall --cask findergitclone
```

### Manual

1. Run `./Scripts/uninstall.sh`
2. Or delete `/Applications/FinderGitClone.app`
3. Disable the extension in System Settings
