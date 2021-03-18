#!/bin/bash

pushd ./example || exit
flutter build web --release
popd || exit
cp -r example/build/web/* ./docs/