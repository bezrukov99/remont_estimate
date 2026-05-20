#!/usr/bin/env bash
# Build a release App Bundle for Google Play.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [[ ! -f android/key.properties ]]; then
  echo "Warning: android/key.properties not found."
  echo "Release will be signed with the debug key (not for Play Store upload)."
  echo "See docs/GOOGLE_PLAY.md and android/key.properties.example"
  echo ""
fi

flutter pub get
flutter build appbundle --release

AAB="build/app/outputs/bundle/release/app-release.aab"
if [[ -f "$AAB" ]]; then
  echo ""
  echo "Done: $AAB"
  ls -lh "$AAB"
else
  echo "Build finished but AAB not found at $AAB" >&2
  exit 1
fi
