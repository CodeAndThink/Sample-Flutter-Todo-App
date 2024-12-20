#!/bin/bash

# Stop if meeting error
set -e 

# Flutter Build APK Script
echo "=== Building Stable Flutter APK ==="

# Clean old build
flutter clean

# Installing dependencies
flutter pub get

# Generating localization's and asset's files
flutter gen-l10n

# Build APK
if flutter build apk --release --flavor production; then
    echo "Building APK successfully!"
    echo "APK's path: build/app/outputs/flutter-apk/app-production-release.apk"
else
    echo "Error: Unable to build APK."
    exit 1
fi
