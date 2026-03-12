#!/usr/bin/env bash
set -euo pipefail

if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter SDK belum ada di PATH." >&2
  exit 1
fi

if [ ! -d android ]; then
  flutter create . --platforms=android
fi

flutter pub get
flutter build apk --debug

echo "APK selesai dibuat: build/app/outputs/flutter-apk/app-debug.apk"
