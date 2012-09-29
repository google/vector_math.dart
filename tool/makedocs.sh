#!/bin/sh

export DART_SDK=~/dart/dart-sdk
$DART_SDK/bin/dart --heap_growth_rate=32 $DART_SDK/pkg/dartdoc/dartdoc.dart --link-api --mode=static ./lib/vector_math_html.dart 
