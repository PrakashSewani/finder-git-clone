#!/bin/bash
set -euo pipefail

APP_NAME="FinderGitClone"
APP_BUNDLE="${APP_NAME}.app"
INSTALL_PATH="/Applications/${APP_BUNDLE}"

echo "Uninstalling ${APP_NAME}..."

if [ -d "${INSTALL_PATH}" ]; then
    echo "Removing ${INSTALL_PATH}..."
    rm -rf "${INSTALL_PATH}"
    echo "Application removed."
else
    echo "${APP_NAME} is not installed in /Applications."
fi

echo ""
echo "To fully remove:"
echo "  1. Open System Settings → Privacy & Security → Extensions → Finder Extensions"
echo "  2. Disable FinderGitClone"
echo "  3. Optionally delete preferences: defaults delete com.findergitclone.app"
echo ""
echo "Uninstall complete."
