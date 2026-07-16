# Packaging

## Building a Release

```bash
./Scripts/build-release.sh
```

This creates:
- A release build in `build/`
- A DMG installer in `dist/`

## Distribution

### Homebrew Cask

The Cask formula is in `Homebrew/findergitclone.rb`. To publish:

1. Create a GitHub release with the DMG
2. Update the Cask formula with the new version and SHA
3. Submit to Homebrew: `brew tap --cask prakashsewani/findergitclone`

### Direct Download

Upload the DMG to GitHub Releases.

### Manual Installation

Copy `FinderGitClone.app` to `/Applications` and enable the extension in System Settings.

## Code Signing

For distribution outside the App Store:

1. Sign the app with your Developer ID:
   ```bash
   codesign --sign "Developer ID Application: Your Name" FinderGitClone.app
   ```

2. Notarize with Apple:
   ```bash
   xcrun notarytool submit FinderGitClone.dmg --apple-id "your@email.com" --team-id YOUR_TEAM_ID
   ```

## Versioning

Follow semantic versioning:
- MAJOR: Breaking changes
- MINOR: New features
- PATCH: Bug fixes

Update version in `App/Sources/Info.plist` before each release.
