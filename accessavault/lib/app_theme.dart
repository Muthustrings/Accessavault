import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF0B2447);
  static const Color secondary = Color(0xFF19376D);
  static const Color accent = Color(0xFF576CBC);
  static const Color background = Color(0xFFF7F9FB);
  static const Color textPrimary = Color(0xFF222222);
  static const Color textSecondary = Color(0xFF666666);
  static const Color chipBackground = Color(0xFFE0E0E0);
}

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  static const TextStyle body = TextStyle(
    fontSize: 18,
    color: AppColors.textPrimary,
  );
  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    color: AppColors.textSecondary,
  );
  static const TextStyle chip = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
  );
}
