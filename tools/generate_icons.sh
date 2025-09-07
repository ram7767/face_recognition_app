#!/usr/bin/env bash
# Generates launcher icons for Android, iOS and web from assets/icons/face_icon.svg
# Requirements: rsvg-convert (librsvg) OR ImageMagick `convert` installed.
# Usage: ./tools/generate_icons.sh
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SVG="$ROOT_DIR/assets/icons/face_icon.svg"
PNG="$ROOT_DIR/assets/icons/face_icon.png"
WEB_DIR="$ROOT_DIR/web/icons"
IOS_APPICON_DIR="$ROOT_DIR/ios/Runner/Assets.xcassets/AppIcon.appiconset"
ANDROID_RES_DIR="$ROOT_DIR/android/app/src/main/res"

mkdir -p "$ROOT_DIR/assets/icons"
mkdir -p "$WEB_DIR"

# Convert SVG to a high-res PNG if possible
if command -v rsvg-convert >/dev/null 2>&1; then
  rsvg-convert -w 2048 -h 2048 "$SVG" -o "$PNG"
elif command -v convert >/dev/null 2>&1; then
  convert -background none -resize 2048x2048 "$SVG" "$PNG"
else
  echo "Please install 'librsvg' (rsvg-convert) or ImageMagick (convert)" >&2
  exit 2
fi

# Helper to make resized PNGs
resize() {
  local size=$1
  local out=$2
  convert "$PNG" -resize ${size}x${size} -background none -gravity center -extent ${size}x${size} "$out"
}

# Web icons
resize 192 "$WEB_DIR/Icon-192.png"
resize 512 "$WEB_DIR/Icon-512.png"
resize 192 "$WEB_DIR/Icon-maskable-192.png"
resize 512 "$WEB_DIR/Icon-maskable-512.png"

# Android mipmaps (square icons)
resize 48 "$ANDROID_RES_DIR/mipmap-mdpi/ic_launcher.png"
resize 72 "$ANDROID_RES_DIR/mipmap-hdpi/ic_launcher.png"
resize 96 "$ANDROID_RES_DIR/mipmap-xhdpi/ic_launcher.png"
resize 144 "$ANDROID_RES_DIR/mipmap-xxhdpi/ic_launcher.png"
resize 192 "$ANDROID_RES_DIR/mipmap-xxxhdpi/ic_launcher.png"

# iOS AppIcon sizes (a subset; update Contents.json if you change filenames)
resize 20 "$IOS_APPICON_DIR/Icon-App-20x20@1x.png"
resize 40 "$IOS_APPICON_DIR/Icon-App-20x20@2x.png"
resize 60 "$IOS_APPICON_DIR/Icon-App-20x20@3x.png"
resize 29 "$IOS_APPICON_DIR/Icon-App-29x29@1x.png"
resize 58 "$IOS_APPICON_DIR/Icon-App-29x29@2x.png"
resize 87 "$IOS_APPICON_DIR/Icon-App-29x29@3x.png"
resize 40 "$IOS_APPICON_DIR/Icon-App-40x40@1x.png"
resize 80 "$IOS_APPICON_DIR/Icon-App-40x40@2x.png"
resize 120 "$IOS_APPICON_DIR/Icon-App-40x40@3x.png"
resize 60 "$IOS_APPICON_DIR/Icon-App-60x60@2x.png"
resize 90 "$IOS_APPICON_DIR/Icon-App-60x60@3x.png"
resize 76 "$IOS_APPICON_DIR/Icon-App-76x76@1x.png"
resize 152 "$IOS_APPICON_DIR/Icon-App-76x76@2x.png"
resize 167 "$IOS_APPICON_DIR/Icon-App-83.5x83.5@2x.png"
resize 1024 "$IOS_APPICON_DIR/Icon-App-1024x1024@1x.png"

# Update web manifest (ensure icons exist)
if [ -f "$ROOT_DIR/web/manifest.json" ]; then
  echo "web/manifest.json exists — ensure it points to web/icons/Icon-192.png and Icon-512.png"
fi

echo "Icons generated and copied. Next steps:\n - Run 'flutter pub get'\n - For Android/iOS, rebuild the app.\n - For web, ensure web/index.html and manifest.json reference the new icons."
