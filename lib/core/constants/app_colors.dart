import 'package:flutter/material.dart';

/// App color palette - inspired by fintech wallet apps
class AppColors {
  AppColors._();

  // Primary colors (Maya Green)
  static const Color primary = Color(0xFF00A652);
  static const Color primaryDark = Color(0xFF008542);
  static const Color primaryLight = Color(0xFF33B873);

  // Secondary colors
  static const Color secondary = Color(0xFF1A1A2E);
  static const Color secondaryLight = Color(0xFF16213E);

  // Accent colors
  static const Color accent = Color(0xFF00A652);
  static const Color accentOrange = Color(0xFFFF8C42);
  static const Color accentBlue = Color(0xFF4A90D9);
  static const Color accentPurple = Color(0xFF7B68EE);

  // Background colors
  static const Color background = Color(0xFFF5F7FA);
  static const Color backgroundDark = Color(0xFF0F0F1A);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1A1A2E);

  // Card gradient colors
  static const Color cardGradientStart = Color(0xFF00A652);
  static const Color cardGradientEnd = Color(0xFF008542);

  // Text colors
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFF9CA3AF);

  // Status colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Transaction colors
  static const Color income = Color(0xFF10B981);
  static const Color expense = Color(0xFFEF4444);

  // Border colors
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFF374151);

  // Shimmer colors
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
}
