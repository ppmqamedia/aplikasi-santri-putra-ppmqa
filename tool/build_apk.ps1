$ErrorActionPreference = 'Stop'

$flutter = Get-Command flutter -ErrorAction SilentlyContinue
if (-not $flutter) {
  throw 'Flutter SDK belum ada di PATH.'
}

if (-not (Test-Path 'android')) {
  flutter create . --platforms=android
}

flutter pub get
flutter build apk --debug
Write-Host 'APK selesai dibuat: build/app/outputs/flutter-apk/app-debug.apk'
