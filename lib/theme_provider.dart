import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final colorThemeProvider = StateProvider<ColorScheme>((ref) {
  return ColorScheme.fromSeed(seedColor: Colors.purple);
});
