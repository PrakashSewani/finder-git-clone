#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
APP_NAME="FinderGitClone"
APP_BUNDLE="${APP_NAME}.app"

cd "$PROJECT_DIR"

echo "1. Generating project..."
xcodegen generate

echo "2. Writing extension Info.plist (after xcodegen)..."
cat > FinderExtension/Sources/Info.plist << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDevelopmentRegion</key>
	<string>en</string>
	<key>CFBundleExecutable</key>
	<string>$(EXECUTABLE_NAME)</string>
	<key>CFBundleIdentifier</key>
	<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	<key>CFBundleName</key>
	<string>FinderGitClone Extension</string>
	<key>CFBundlePackageType</key>
	<string>XPC!</string>
	<key>CFBundleShortVersionString</key>
	<string>1.0.0</string>
	<key>CFBundleVersion</key>
	<string>1</string>
	<key>LSMinimumSystemVersion</key>
	<string>$(MACOSX_DEPLOYMENT_TARGET)</string>
	<key>NSExtension</key>
	<dict>
		<key>NSExtensionPointIdentifier</key>
		<string>com.apple.FinderSync</string>
		<key>NSExtensionPrincipalClass</key>
		<string>$(PRODUCT_MODULE_NAME).FinderSyncExtension</string>
	</dict>
</dict>
</plist>
PLIST

echo "3. Writing entitlements..."
cat > Entitlements/FinderExtension.entitlements << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.security.app-sandbox</key>
    <true/>
    <key>com.apple.security.application-groups</key>
    <array>
        <string>group.com.findergitclone.app</string>
    </array>
</dict>
</plist>
PLIST

cat > Entitlements/App.entitlements << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.security.application-groups</key>
    <array>
        <string>group.com.findergitclone.app</string>
    </array>
</dict>
</plist>
PLIST

echo "4. Building..."
xcodebuild -scheme FinderGitClone -configuration Debug build 2>&1 | grep -E "(BUILD|error:)" | tail -5

BUILD_APP=$(find ~/Library/Developer/Xcode/DerivedData/FinderGitClone-*/Build/Products/Debug -name "${APP_BUNDLE}" -type d | head -1)
if [ -z "$BUILD_APP" ]; then
    echo "ERROR: Built app not found"
    exit 1
fi

echo "5. Installing to /Applications..."
killall "$APP_NAME" 2>/dev/null || true
rm -rf "/Applications/${APP_BUNDLE}"
cp -R "$BUILD_APP" "/Applications/"

echo "6. Signing..."
codesign --sign "FinderGitClone Dev" --keychain fc_dev.keychain --force \
    --entitlements /tmp/fc_ext_ent.plist \
    "/Applications/${APP_BUNDLE}/Contents/PlugIns/FinderExtension.appex" 2>&1

codesign --sign "FinderGitClone Dev" --keychain fc_dev.keychain --force \
    --entitlements /tmp/fc_app_ent.plist \
    "/Applications/${APP_BUNDLE}" 2>&1

echo "7. Verifying..."
echo "   Extension:"
codesign -d --entitlements - "/Applications/${APP_BUNDLE}/Contents/PlugIns/FinderExtension.appex" 2>&1

echo ""
echo "8. Registering extension..."
pluginkit -a "/Applications/${APP_BUNDLE}/Contents/PlugIns/FinderExtension.appex" 2>&1 || true

echo "9. Restarting Finder..."
killall Finder 2>/dev/null || true

echo "10. Launching app..."
open "/Applications/${APP_BUNDLE}"

echo ""
echo "Done! Enable the extension in:"
echo "  System Settings -> General -> Login Items & Extensions -> Finder Extensions"
echo "  Toggle on FinderGitClone"
