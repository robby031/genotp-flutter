#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VERSION_FILE="$ROOT_DIR/tool/mobile_artifact_version.txt"
VERSION="${1:-$(tr -d '[:space:]' < "$VERSION_FILE")}"

if [[ -z "$VERSION" ]]; then
  echo "Missing genotp-mobile version" >&2
  exit 1
fi

BASE_URL="https://github.com/robby031/genotp-mobile/releases/download/${VERSION}"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

download() {
  local file="$1"
  curl -fsSL "$BASE_URL/$file" -o "$TMP_DIR/$file"
}

echo "Downloading genotp-mobile artifacts for ${VERSION}..."
download "genotp.aar"
download "Genotp.xcframework.zip"
download "genotp-sources.jar"
download "SHA256SUMS"

(
  cd "$TMP_DIR"
  shasum -a 256 -c SHA256SUMS
)

rm -f "$ROOT_DIR/android/libs/genotp.aar" "$ROOT_DIR/android/libs/genotp.jar"
rm -rf "$ROOT_DIR/android/src/main/jniLibs"
mkdir -p "$ROOT_DIR/android/libs" "$ROOT_DIR/android/src/main/jniLibs"

unzip -oq "$TMP_DIR/genotp.aar" -d "$TMP_DIR/android-aar"
cp "$TMP_DIR/android-aar/classes.jar" "$ROOT_DIR/android/libs/genotp.jar"
cp "$TMP_DIR/android-aar/proguard.txt" "$ROOT_DIR/android/consumer-rules.pro"
cp -R "$TMP_DIR/android-aar/jni/." "$ROOT_DIR/android/src/main/jniLibs/"

rm -rf "$ROOT_DIR/ios/genotp_flutter/Genotp.xcframework" "$ROOT_DIR/ios/Frameworks/Genotp.xcframework"
mkdir -p "$ROOT_DIR/ios/genotp_flutter"
unzip -oq "$TMP_DIR/Genotp.xcframework.zip" -d "$TMP_DIR/ios"
cp -R "$TMP_DIR/ios/Genotp.xcframework" "$ROOT_DIR/ios/genotp_flutter/Genotp.xcframework"

printf '%s\n' "$VERSION" > "$VERSION_FILE"

echo "Synchronized genotp-mobile artifacts ${VERSION}"
