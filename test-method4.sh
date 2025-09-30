#!/bin/bash
# Test Method 4: Clone private repo using token passed as environment variable
# This demonstrates how to use secrets securely in external scripts

set -e  # Exit on error

echo "==================================="
echo "Method 4: Script-based Clone"
echo "==================================="
echo ""

# Check if INSTALL_TOKEN is set
if [ -z "$INSTALL_TOKEN" ]; then
    echo "ERROR: INSTALL_TOKEN environment variable is not set"
    exit 1
fi

echo "✓ Token is available (masked in logs)"
echo ""

# Define variables
REPO_ORG="Aidans-test-org"
REPO_NAME="test-repo2-private"
CLONE_DIR="private-repo-method4"

echo "📥 Cloning private repository..."
echo "  Repository: $REPO_ORG/$REPO_NAME"
echo "  Destination: $CLONE_DIR"
echo ""

# Clone the repository using the token
# Token is passed via environment variable, not exposed in command
git clone --depth 1 \
  https://x-access-token:${INSTALL_TOKEN}@github.com/${REPO_ORG}/${REPO_NAME}.git \
  "$CLONE_DIR" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✓ Clone successful!"
else
    echo "✗ Clone failed!"
    exit 1
fi
echo ""

# Remove .git directory to eliminate any trace of credentials
echo "🧹 Cleaning up git metadata..."
rm -rf "$CLONE_DIR/.git"
echo "✓ Removed .git directory"
echo ""

# Analyze the cloned repository
echo "📊 Repository analysis:"
file_count=$(find "$CLONE_DIR" -type f 2>/dev/null | wc -l)
echo "  - Total files: $file_count"

if [ -f "$CLONE_DIR/README.md" ]; then
    echo "  - Found README.md"
fi

echo ""

# Create workspace and copy files
WORKSPACE="./workspace-method4"
mkdir -p "$WORKSPACE"
cp -r "$CLONE_DIR"/* "$WORKSPACE/" 2>/dev/null || true
echo "✓ Files copied to: $WORKSPACE"
echo ""

echo "==================================="
echo "✓ Method 4 Complete!"
echo "==================================="
echo ""
echo "Private repo is now available in:"
echo "  - $CLONE_DIR/"
echo "  - $WORKSPACE/"

