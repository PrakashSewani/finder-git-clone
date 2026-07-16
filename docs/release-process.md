# Release Process

## Pre-Release

1. Update version in `App/Sources/Info.plist`
2. Update CHANGELOG.md
3. Run full test suite: `swift test`
4. Build and test manually
5. Create a release branch: `git release/v{VERSION}`

## Release

1. Merge release branch to main
2. Tag the release: `git tag v{VERSION}`
3. Build the DMG: `./Scripts/build-release.sh`
4. Create GitHub Release with DMG
5. Update Homebrew Cask formula
6. Push tag: `git push origin v{VERSION}`

## Post-Release

1. Verify Homebrew Cask works: `brew install --cask findergitclone`
2. Monitor GitHub Issues for issues
3. Update documentation if needed

## Hotfix Process

1. Create hotfix branch from release tag
2. Make fix
3. Test thoroughly
4. Create new patch release
5. Follow standard release process
