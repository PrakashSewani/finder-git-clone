#!/bin/bash
set -euo pipefail

APP_NAME="FinderGitClone"
APP_BUNDLE="${APP_NAME}.app"
INSTALL_DIR="/Applications"
INSTALL_PATH="${INSTALL_DIR}/${APP_BUNDLE}"

echo "Installing ${APP_NAME}..."

if [ -d "${INSTALL_PATH}" ]; then
    echo "Previous installation found. Removing..."
    rm -rf "${INSTALL_PATH}"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "${SCRIPT_DIR}")"
BUILD_DIR="${PROJECT_DIR}/build"

if [ ! -d "${BUILD_DIR}/Release/${APP_BUNDLE}" ]; then
    echo "Build not found. Building..."
    cd "${PROJECT_DIR}"
    xcodebuild -project FinderGitClone.xcodeproj \
        -scheme FinderGitClone \
        -configuration Release \
        -derivedDataPath "${BUILD_DIR}" \
        build
fi

echo "Copying to ${INSTALL_DIR}..."
cp -R "${BUILD_DIR}/Build/Products/Release/${APP_BUNDLE}" "${INSTALL_DIR}/"

echo "Registering URL scheme..."
/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -f "${INSTALL_PATH}"

echo ""
echo "Installation complete!"
echo ""
echo "Next steps:"
echo "  1. Open System Settings"
echo "  2. Go to Privacy & Security → Extensions → Finder Extensions"
echo "  3. Enable FinderGitClone"
echo ""
echo "You can now right-click any folder in Finder and select 'Clone Repository...'"
