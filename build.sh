#!/bin/bash

# Exit on error
set -e

echo "Downloading Flutter..."
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable
fi

echo "Adding Flutter to PATH..."
export PATH="$PATH:`pwd`/flutter/bin"

echo "Building Flutter Web..."
flutter config --enable-web
flutter build web --release
