#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "${SCRIPT_DIR}")"
BUILD_DIR="${PROJECT_DIR}/build"
DIST_DIR="${PROJECT_DIR}/dist"
APP_NAME="FinderGitClone"
APP_BUNDLE="${APP_NAME}.app"
VERSION=$(grep -m1 'CFBundleShortVersionString' "${PROJECT_DIR}/App/Sources/Info.plist" | sed 's/.*>\(.*\)<.*/\1/')
DMG_NAME="${APP_NAME}-${VERSION}.dmg"

echo "Building ${APP_NAME} v${VERSION}..."

cd "${PROJECT_DIR}"

rm -rf "${BUILD_DIR}" "${DIST_DIR}"
mkdir -p "${DIST_DIR}"

xcodebuild -project FinderGitClone.xcodeproj \
    -scheme FinderGitClone \
    -configuration Release \
    -derivedDataPath "${BUILD_DIR}" \
    build

APP_PATH="${BUILD_DIR}/Build/Products/Release/${APP_BUNDLE}"

if [ ! -d "${APP_PATH}" ]; then
    echo "Error: Build failed. App not found at ${APP_PATH}"
    exit 1
fi

echo "Creating DMG..."

DMG_PATH="${DIST_DIR}/${DMG_NAME}"

hdiutil create -volname "${APP_NAME}" \
    -srcfolder "${APP_PATH}" \
    -ov -format UDZO \
    "${DMG_PATH}"

echo ""
echo "Build complete!"
echo "App: ${APP_PATH}"
echo "DMG: ${DMG_PATH}"
echo ""
echo "To install:"
echo "  1. Mount the DMG"
echo "  2. Drag ${APP_BUNDLE} to /Applications"
echo "  3. Enable the Finder extension in System Settings"
