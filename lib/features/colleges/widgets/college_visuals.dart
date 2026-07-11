import 'package:flutter/material.dart';

/// Deterministic accent-color picker so every college gets a stable, varied
/// logo color without needing real logo assets.
const List<Color> _collegePalette = [
  Color(0xFF3B82F6),
  Color(0xFF22C55E),
  Color(0xFFF97316),
  Color(0xFFA855F7),
  Color(0xFF14B8A6),
  Color(0xFFEF4444),
  Color(0xFF06B6D4),
  Color(0xFFEAB308),
];

Color collegeAccentColor(String id) {
  final hash = id.codeUnits.fold<int>(0, (a, b) => a + b);
  return _collegePalette[hash % _collegePalette.length];
}
