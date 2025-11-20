// lib/constants/qr_colors.dart
import 'package:flutter/material.dart';

//yapay zeka
class QRColorPresets {
  static const instagram = [Color(0xFF833AB4), Color(0xFFFD1D1D)];
  static const ocean = [Color(0xFF2E3192), Color(0xFF1BFFFF)];
  static const sunset = [Color(0xFFFF512F), Color(0xFFDD2476)];
  static const forest = [Color(0xFF134E5E), Color(0xFF71B280)];
  static const fire = [Color(0xFFFF0844), Color(0xFFFFB199)];
  static const purple = [Color(0xFF667EEA), Color(0xFF764BA2)];

  static Map<String, List<Color>> get all => {
    'Instagram': instagram,
    'Ocean': ocean,
    'Sunset': sunset,
    'Forest': forest,
    'Fire': fire,
    'Purple': purple,
  };
}
