# Troubleshooting

## "Clone Repository..." doesn't appear in context menu

**Cause:** The Finder extension is not enabled.

**Fix:**
1. Open System Settings
2. Go to Privacy & Security → Extensions → Finder Extensions
3. Enable FinderGitClone
4. Restart Finder: `killall Finder`

## "Git is not installed" error

**Cause:** Git is not found in your PATH.

**Fix:**
```bash
# Install Xcode Command Line Tools
xcode-select --install

# Or install via Homebrew
brew install git
```

## "Authentication failed" error

**Cause:** Git cannot authenticate with the remote repository.

**Fix:**
- For HTTPS: Ensure your credential helper is configured
  ```bash
  git config --global credential.helper osxkeychain
  ```
- For SSH: Ensure your SSH key is added to the agent
  ```bash
  ssh-add ~/.ssh/id_rsa
  ```
- For GitHub: Consider using GitHub CLI for authentication
  ```bash
  brew install gh
  gh auth login
  ```

## "Repository not found" error

**Cause:** The URL is incorrect or the repository is private.

**Fix:**
- Verify the URL is correct
- Ensure you have access to the repository
- Try cloning manually in Terminal to debug

## Clone hangs or is very slow

**Cause:** Network issues or large repository.

**Fix:**
- Check your internet connection
- Try a shallow clone (use More Options → Depth)
- Try cloning manually in Terminal

## App doesn't open after clicking context menu

**Cause:** The app may need to be registered with Launch Services.

**Fix:**
```bash
/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -f /Applications/FinderGitClone.app
```

## Extension stops working after macOS update

**Cause:** macOS updates can disable extensions.

**Fix:**
1. Open System Settings
2. Re-enable FinderGitClone in Extensions
3. Restart Finder

## How to view extension logs

1. Open Console.app
2. Search for "FinderGitClone"
3. Look for error messages

## How to reset preferences

```bash
defaults delete com.findergitclone.app
```

## SSH key not working

**Cause:** The SSH agent doesn't have your key loaded.

**Fix:**
```bash
# Start the SSH agent
eval "$(ssh-agent -s)"

# Add your key
ssh-add ~/.ssh/id_rsa

# Test SSH connection
ssh -T git@github.com
```

## App crashes on launch

**Cause:** Possible corrupted preferences or cache.

**Fix:**
```bash
# Remove preferences
defaults delete com.findergitclone.app

# Remove app and reinstall
rm -rf /Applications/FinderGitClone.app
```
