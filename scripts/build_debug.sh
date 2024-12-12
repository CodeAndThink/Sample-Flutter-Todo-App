#!/bin/bash

# Stop if meeting error
set -e 

# Flutter Build APK Script
echo "=== Building Flutter Debug ==="

# Clean old build
flutter clean

# Installing dependencies
flutter pub get

# Generating localization's and asset's files
flutter gen-l10n

# Build APK
if flutter run; then
    echo "Building debug successfully!"
else
    echo "Error: Unable to build debug."
    exit 1
fi
