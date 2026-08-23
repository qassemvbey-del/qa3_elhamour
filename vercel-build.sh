#!/bin/bash
if cd flutter; then
  git pull
  cd ..
else
  git clone https://github.com/flutter/flutter.git --depth 1 -b stable
fi
export PATH="$PATH:`pwd`/flutter/bin"
flutter channel stable
flutter upgrade
flutter config --enable-web
flutter build web --release
